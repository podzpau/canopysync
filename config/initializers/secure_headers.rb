SecureHeaders::Configuration.default do |config|
  config.x_frame_options = "DENY"
  config.x_content_type_options = "nosniff"
  config.x_xss_protection = "0" # Disabled per modern best practice (CSP replaces it)
  config.referrer_policy = %w[strict-origin-when-cross-origin]
  config.x_permitted_cross_domain_policies = "none"

  config.csp = {
    default_src: %w['self'],
    script_src: %w['self' 'unsafe-inline' https://cdn.jsdelivr.net],
    style_src: %w['self' 'unsafe-inline' https://fonts.googleapis.com],
    font_src: %w['self' https://fonts.gstatic.com],
    img_src: %w['self' data: https:],
    connect_src: %w['self'],
    frame_src: %w['self'],
    object_src: %w['none'],
    base_uri: %w['self'],
    form_action: %w['self'],
    frame_ancestors: %w['self']
  }

  # Permissions-Policy: set via custom header in ApplicationController
  # (secure_headers 7.x delegates this to app layer)
end
