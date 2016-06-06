require 'healthcheck_middleware'
use HealthcheckMiddleware::HACheck

require ::File.expand_path('../config/initializer', __FILE__)
require ::File.expand_path('../app/api', __FILE__)
require ::File.expand_path('../config/initializers/sidekiq', __FILE__)
require 'sidekiq/web'
require 'stats/stats'

run Rack::URLMap.new(
  '/ui'       => Protected,
  '/'         => FBApp,
  '/sidekiq'  => Sidekiq::Web,
  '/stats'    => BrokerStats::Stats
)

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == [Broker.sidekiq['monitoring']['username'], Broker.sidekiq['monitoring']['password']]
end

require 'newrelic_rpm'
if defined?(Unicorn) && File.basename($0).start_with?('unicorn')
  ::NewRelic::Agent.manual_start()
  ::NewRelic::Agent.after_fork(:force_reconnect => true)
end
