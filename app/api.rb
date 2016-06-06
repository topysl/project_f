# encoding: utf-8

require 'brokerizer/api'
require './app/helper/auth'
require './app/helper/asset'
require './app/helper/publisher_api'
require './app/helper/mailer'
require './app/helper/engage_helper'
require './app/helper/health_checker'
require './lib/workers/accounts/token_helper'
require './lib/workers/publisher/publisher_worker_helper'
require 'mail'
require 'brokerizer/api_helpers/analytics_api'


# linkedin broker api endpoints
class FBApp < API
  helpers Sinatra::Jsonp
  helpers Sinatra::AuthHelper
  helpers Sinatra::AssetHelper
  helpers Sinatra::PublisherApiHelper
  helpers Sinatra::MailerHelper
  helpers Sinatra::EngageHelper
  helpers Workers::AccountsWorkerHelper
  helpers LinkedinBroker::HealthChecker
  helpers Sinatra::AnalyticsApiHelper
  helpers Workers::PublisherWorkerHelper




end


https://www.facebook.com/login.php?skip_api_login=1&api_key=183495021668795&signed_next=1&
next=https%3A%2F%2Fwww.facebook.com%2Fv2.2%2Fdialog%2Foauth%3Fredirect_uri%3Dhttps%253A%252F%252Fstaticxx.facebook.com%252Fconnect%252Fxd_arbiter.php%253Fversion%253D42%2523cb%253Df2481c3323f854%2526domain%253D
tabs.vitrue.com%2526origin%253Dhttps%25253A%25252F%25252Ftabs.vitrue.com%25252Ff30774b49bb7b%2526relation%253Dopener%2526frame%253Df201d02ef74b594%26display%3Dpopup%26scope%3Dmanage_pages%26response_type%3Dtoken%252Csigned_request%26domain%3Dtabs.vitrue.com%26origin%3D1%26client_id%3D183495021668795%26ret%3Dlogin%26sdk%3Djoey%26logger_id%3Db5a256db-2776-4d9d-b387-0d904b71d8de&cancel_url=https%3A%2F%2Fstaticxx.facebook.com%2Fconnect%2Fxd_arbiter.php%3Fversion%3D42%23cb%3Df2481c3323f854%26domain%3Dtabs.vitrue.com%26origin%3Dhttps%253A%252F%252Ftabs.vitrue.com%252Ff30774b49bb7b%26relation%3Dopener%26frame%3Df201d02ef74b594%26error%3Daccess_denied%26error_code%3D200%26error_description%3DPermissions%2Berror%26error_reason%3Duser_denied%26e2e%3D%257B%257D&display=popup&locale=en_GB&logger_id=b5a256db-2776-4d9d-b387-0d904b71d8de
