class PermissionsPolicyMiddleware
  HEADER = "Permissions-Policy"
  VALUE  = "camera=(), geolocation=(), microphone=(), payment=(), usb=()"

  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    headers[HEADER] ||= VALUE
    [status, headers, body]
  end
end
