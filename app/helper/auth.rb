
module Sinatra
  module AuthHelper
    def get_accounts_redirect_url(params)
      # user_info is encoded in state param for linkedin oauth2
      params.merge!(JSON.parse(Base64.decode64(params[:state])))
      super(params)
    end

    def get_authorize_url(to_write, accounts_user_id, resource_identifier)
      Broker.logger[:app].info('Method called', instance: self.__id__, clazz: self.class.name, method: __method__,
        to_write: to_write, accounts_user_id: accounts_user_id, resource_identifier: resource_identifier)
      args = {}
      if accounts_user_id && resource_identifier
        args[:accounts_user_id] = accounts_user_id
        Broker.redis.set(accounts_user_id, resource_identifier)
      end
      authorization_url = LinkedInRequest::Authorization.authorization_url(args)
      Broker.logger[:app].debug('Variable authorization_url generated', authorization_url: authorization_url)
      authorization_url
    end

    def get_access_token(to_write, code, request_token)
      Broker.logger[:app].info('Method called', instance: self.__id__, clazz: self.class.name, method: __method__,
        to_write: to_write, code: code, request_token: request_token)
      LinkedInRequest::Authorization.get_access_token(code)
    end

    def available_streams(auth_by_identifier)
      Broker.logger[:app].info('Method called', instance: self.__id__, clazz: self.class.name, method: __method__,
        auth_by_identifier: auth_by_identifier)
      LinkedInRequest::Company.admin_companies(auth_by_identifier)
    end

    def generate_cancel_redirect_url?(params)
      !params.nil? && params['error'] == 'access_denied'
    end

    def validate_and_parse_auth_params(params)
      validate_params(['code'], params)
      { 'code' => params['code'] }
    end

    def update_all_tokens_for_user_id (auth_by_identifier, token, new_token_status)
      Broker.logger[:app].info('Method called', instance: self.__id__, clazz: self.class.name, method: __method__,
        auth_by_identifier: auth_by_identifier)
      companies = Broker.redis.get("#{::BrokerConstants::TYPE}:AUTH_BY_IDENTIFIER:#{auth_by_identifier}")
      if companies
        companies = JSON(companies)
      else
        companies = LinkedInRequest::Company.admin_companies(auth_by_identifier)
      end

      return if companies.blank?

      resources = Broker.database[:resources].where(auth_by_identifier: auth_by_identifier)
      resources.each do |resource|
        if companies.detect { |page| page.symbolize_keys[:id] == resource[:identifier] }
          BrokerUtils::AccountsHelper.update_is_alive_status(resource[:identifier], nil, new_token_status, token)
        end
      end
    end
  end

  helpers AuthHelper
end
