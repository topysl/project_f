# encoding: utf-8
RACK_ENV = ENV['RACK_ENV'] || 'development'

require 'rubygems'
require 'yaml'
require 'json'
require 'logger'
require 'net/http'
require 'sinatra'
require 'sinatra/base'
require 'sinatra/jsonp'
require 'active_support/core_ext/hash'
require 'active_support/core_ext/object'
require 'brokerizer/broker'
require 'i18n'
require 'i18n/backend/fallbacks'
require 'stats/stats'
require 'stats/broker_auditor'

I18n.load_path = Dir[File.join(File.expand_path('.'), 'public', 'nls','*.yml')]
I18n.backend.load_translations

$project_root = File.expand_path('.')
ENV['RACK_ROOT'] = $project_root

# LOGGER SETTINGS
logfile = ::File.expand_path("#{ $project_root }/log/#{ RACK_ENV }.log", __FILE__)
# TO-DO: add comment
class ::Logger
  alias_method :write, :<<
end
$logger = ::Logger.new(logfile)

case RACK_ENV
  when 'development', 'test'
    $logger.level = Logger::DEBUG
    require 'debugger'
  when 'integration', 'sandbox', 'staging', 'production'
    $logger.level = Logger::ERROR
end

use Rack::CommonLogger, $logger

Broker.init($project_root, [:redis, :gatekeeper, :database, :sidekiq, :proxy, :rmq, :publisher])
BrokerAuditor.init(Broker)

ENV['http_proxy'] = Broker.proxy['http_proxy_url'] if Broker.proxy['http_proxy_url']
ENV['https_proxy'] = Broker.proxy['https_proxy_url'] if Broker.proxy['https_proxy_url']
ENV['no_proxy'] = Broker.proxy['no_proxy'] if Broker.proxy['no_proxy']

# NOTE: These are quick fixes for the Engage workers. Need to refactor later.
require 'brokerizer/errors'

DB = Broker.database
require './config/database'
require 'stats/model'
require './app/api'

$rabbitmq_config = YAML.load(ERB.new(File.read("#{$project_root}/config/rabbitmq.yml")).result)[ENV['RACK_ENV']]

# Following is to configure i18n to be used by broker
# Broker will need to get the current locale from the caller and
# user pass this locale to I18n to get the translation (eg. I18n.t :edit_social_property_type_tumblr, :locale => :de)
configure do
  I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
  I18n.load_path = Dir[File.join("#{$project_root}/config", 'locales', '*.yml')]
  I18n.backend.load_translations
end
