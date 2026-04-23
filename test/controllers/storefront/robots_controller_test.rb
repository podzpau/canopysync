require "test_helper"

class Storefront::RobotsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @shop = shops(:one)
    host! @shop.domain
  end

  test "robots.txt returns text/plain" do
    get "/robots.txt"
    assert_response :success
    assert_equal "text/plain", response.media_type
  end

  test "robots.txt contains User-agent wildcard" do
    get "/robots.txt"
    assert_includes response.body, "User-agent: *"
  end

  test "robots.txt disallows admin paths" do
    get "/robots.txt"
    assert_includes response.body, "Disallow: /admin/"
  end

  test "robots.txt includes sitemap URL" do
    get "/robots.txt"
    assert_includes response.body, "Sitemap: https://#{@shop.domain}/sitemap.xml"
  end

  test "robots.txt returns 404 when shop not found" do
    host! "unknown.test"
    get "/robots.txt"
    assert_response :not_found
  end

  test "robots.txt does not redirect to trailing slash" do
    get "/robots.txt"
    assert_response :success
  end
end
