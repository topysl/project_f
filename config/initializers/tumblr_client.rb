#require "tumblr_client"
#require "./config/initializers/ip"
#TUMBLR_URL = "http://tumblr.com"
#
#Tumblr.configure do |config|
#  config.client_id = Broker.settings['read_client_id']
#  config.client_secret = Broker.settings['read_client_secret']
#  config.client_ips = $local_ip
#  config.proxy = Broker.proxy['http_proxy_url']
#end
