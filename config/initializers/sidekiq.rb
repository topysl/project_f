# encoding: utf-8

require 'sidekiq'
require 'sidekiq-pro'
require 'sidekiq-failures'
require 'sidekiq-middleware'

# This is an extension to make sure sidekiq locks work with the web UI.
require './lib/workers/sidekiq.rb'

redis_config = YAML.load(ERB.new(File.read('./config/redis.yml')).result)[RACK_ENV]

Sidekiq.configure_server do |config|
  require 'sidekiq/pro/reliable_fetch'
  config.redis = {
    url: ENV['REDIS_URL'] || "redis://#{redis_config['host']}:#{redis_config['port']}/#{redis_config['db']}",
    namespace: redis_config['namespace'],
    pool_timeout: 10
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: ENV['REDIS_URL'] || "redis://#{redis_config['host']}:#{redis_config['port']}/#{redis_config['db']}",
    namespace: redis_config['namespace'],
    pool_timeout: 10
  }
end
