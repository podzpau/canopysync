require "test_helper"

# Verifies that HTTP security headers are present on storefront and admin responses.
class SecurityHeadersTest < ActionDispatch::IntegrationTest
  setup do
    @shop = shops(:one)
    host! @shop.domain
  end

  # --- storefront page ---

  test "X-Frame-Options is DENY on storefront" do
    get "/product/#{products(:blue_dream).slug}/"
    assert_equal "DENY", response.headers["X-Frame-Options"]
  end

  test "X-Content-Type-Options is nosniff on storefront" do
    get "/product/#{products(:blue_dream).slug}/"
    assert_equal "nosniff", response.headers["X-Content-Type-Options"]
  end

  test "Content-Security-Policy header present on storefront" do
    get "/product/#{products(:blue_dream).slug}/"
    assert response.headers["Content-Security-Policy"].present?,
      "Expected Content-Security-Policy header to be set"
  end

  test "CSP restricts default-src to self" do
    get "/product/#{products(:blue_dream).slug}/"
    csp = response.headers["Content-Security-Policy"]
    assert_includes csp, "default-src"
    assert_includes csp, "'self'"
  end

  test "CSP sets frame-ancestors to none" do
    get "/product/#{products(:blue_dream).slug}/"
    assert_includes response.headers["Content-Security-Policy"], "frame-ancestors"
  end

  test "CSP sets object-src to none" do
    get "/product/#{products(:blue_dream).slug}/"
    assert_includes response.headers["Content-Security-Policy"], "object-src"
  end

  test "Referrer-Policy is strict-origin-when-cross-origin on storefront" do
    get "/product/#{products(:blue_dream).slug}/"
    assert_includes response.headers["Referrer-Policy"], "strict-origin-when-cross-origin"
  end

  test "X-Permitted-Cross-Domain-Policies is none on storefront" do
    get "/product/#{products(:blue_dream).slug}/"
    assert_equal "none", response.headers["X-Permitted-Cross-Domain-Policies"]
  end

  test "Permissions-Policy header present on storefront" do
    get "/product/#{products(:blue_dream).slug}/"
    assert response.headers["Permissions-Policy"].present?,
      "Expected Permissions-Policy header to be set"
  end

  test "Permissions-Policy restricts camera and geolocation" do
    get "/product/#{products(:blue_dream).slug}/"
    policy = response.headers["Permissions-Policy"]
    assert_includes policy, "camera=()"
    assert_includes policy, "geolocation=()"
  end

  # --- admin login page ---

  test "X-Frame-Options is DENY on admin login" do
    get admin_login_path
    assert_equal "DENY", response.headers["X-Frame-Options"]
  end

  test "X-Content-Type-Options is nosniff on admin login" do
    get admin_login_path
    assert_equal "nosniff", response.headers["X-Content-Type-Options"]
  end

  test "Content-Security-Policy present on admin login" do
    get admin_login_path
    assert response.headers["Content-Security-Policy"].present?
  end
end
