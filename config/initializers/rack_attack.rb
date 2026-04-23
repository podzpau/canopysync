Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
Rack::Attack.enabled = !Rails.env.test?

class Rack::Attack
  ### Throttle all requests by IP ###
  # 300 requests per 5 minutes per IP
  throttle("req/ip", limit: 300, period: 5.minutes) do |req|
    req.ip unless req.path.start_with?("/assets", "/up")
  end

  ### Throttle login attempts ###
  # 5 login attempts per 20 seconds per IP
  throttle("logins/ip", limit: 5, period: 20.seconds) do |req|
    req.ip if req.path == "/admin/login" && req.post?
  end

  # 5 login attempts per email per minute
  throttle("logins/email", limit: 5, period: 60.seconds) do |req|
    if req.path == "/admin/login" && req.post?
      req.params.dig("email")&.to_s&.downcase&.strip
    end
  end

  ### Throttle sitemap requests ###
  # 10 sitemap requests per minute per IP
  throttle("sitemaps/ip", limit: 10, period: 1.minute) do |req|
    req.ip if req.path.start_with?("/sitemap")
  end

  ### Block blank user agents ###
  blocklist("block bad UA") do |req|
    Rack::Attack::Fail2Ban.filter("bad-ua-#{req.ip}", maxretry: 3, findtime: 10.minutes, bantime: 1.hour) do
      req.user_agent.blank?
    end
  end

  ### Custom throttle response ###
  self.throttled_responder = lambda do |_request|
    [429, { "Content-Type" => "text/plain" }, ["Rate limit exceeded. Retry later.\n"]]
  end
end
