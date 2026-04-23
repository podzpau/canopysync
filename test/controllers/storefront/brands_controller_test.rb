require "test_helper"

class Storefront::BrandsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @shop = shops(:one)
    @brand = brands(:cannabis_co)
  end

  test "shows brand" do
    host! @shop.domain
    get "/brand/#{@brand.slug}/"
    assert_response :success
    assert_includes response.body, @brand.name
    assert_includes response.body, "application/ld+json"
  end

  test "returns 404 for missing brand" do
    host! @shop.domain
    get "/brand/nonexistent-brand/"
    assert_response :not_found
  end

  test "returns 404 when shop not found" do
    host! "unknown.test"
    get "/brand/#{@brand.slug}/"
    assert_response :not_found
  end

  test "does not return brand from other shop" do
    host! shops(:two).domain
    get "/brand/#{@brand.slug}/"
    assert_response :not_found
  end

  test "redirects to trailing slash" do
    host! @shop.domain
    get "/brand/#{@brand.slug}"
    assert_redirected_to "/brand/#{@brand.slug}/"
    assert_response :moved_permanently
  end
end
