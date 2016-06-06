Koala.config.api_version = "v2.2"

AppConfig[:proxy_options].tap do |options|
  unless options[:proxy_host].blank?
    Koala.http_service.http_options = {
      :proxy => "http://#{options[:proxy_host]}:#{options[:proxy_port]}"
    }
    puts "Proxying Koala: #{Koala.http_service.http_options[:proxy]}"
  end
end
