require "test_helper"

# Tests for Rack::Attack rate-limiting configuration.
# Rack::Attack is disabled in normal test env (see initializer). These tests
# re-enable it for the duration of each test and reset cache after.
class RackAttackTest < ActionDispatch::IntegrationTest
  setup do
    Rack::Attack.enabled = true
    Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
    host! shops(:one).domain
  end

  teardown do
    Rack::Attack.enabled = false
    Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
  end

  # --- login throttle by IP ---

  test "allows up to 5 login attempts per IP" do
    5.times do
      post admin_login_path, params: { email: "bad@example.com", password: "wrong" },
           headers: { "REMOTE_ADDR" => "1.2.3.4", "HTTP_USER_AGENT" => "TestBrowser/1.0" }
      assert_not_equal 429, response.status, "Should not throttle before limit"
    end
  end

  test "blocks 6th login attempt from same IP within period" do
    6.times do
      post admin_login_path, params: { email: "bad@example.com", password: "wrong" },
           headers: { "REMOTE_ADDR" => "1.2.3.5", "HTTP_USER_AGENT" => "TestBrowser/1.0" }
    end
    assert_equal 429, response.status
    assert_includes response.body, "Rate limit exceeded"
  end

  # --- login throttle by email ---

  test "blocks 6th login attempt for same email within period" do
    6.times do |i|
      post admin_login_path, params: { email: "target@example.com", password: "wrong" },
           headers: { "REMOTE_ADDR" => "10.0.0.#{i + 1}", "HTTP_USER_AGENT" => "TestBrowser/1.0" }
    end
    assert_equal 429, response.status
  end

  # --- throttle response format ---

  test "throttled response is plain text" do
    7.times do
      post admin_login_path, params: { email: "flood@example.com", password: "x" },
           headers: { "REMOTE_ADDR" => "5.5.5.5", "HTTP_USER_AGENT" => "TestBrowser/1.0" }
    end
    assert_equal "text/plain", response.media_type
  end

  # --- sitemap throttle ---

  test "allows up to 10 sitemap requests per IP per minute" do
    10.times do
      get "/sitemap.xml",
          headers: { "REMOTE_ADDR" => "2.2.2.2", "HTTP_USER_AGENT" => "Googlebot/2.1" }
      assert_not_equal 429, response.status
    end
  end

  test "blocks 11th sitemap request from same IP" do
    11.times do
      get "/sitemap.xml",
          headers: { "REMOTE_ADDR" => "3.3.3.3", "HTTP_USER_AGENT" => "Googlebot/2.1" }
    end
    assert_equal 429, response.status
  end
end
