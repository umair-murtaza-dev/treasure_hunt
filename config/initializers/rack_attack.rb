require "ipaddr"


Rack::Attack.cache.store = ActiveSupport::Cache::RedisStore.new("redis://redis:6379/3")

class Rack::Attack
  class Request < ::Rack::Request
    def remote_ip
      @remote_ip ||= (env["HTTP_REFERRER"] || env["action_dispatch.remote_ip"] || ip).to_s
    end
  end

  throttle("ip:request-limit-per-hour", limit: 20, period: 1.hour) do |req|
    req.remote_ip
  end
end
