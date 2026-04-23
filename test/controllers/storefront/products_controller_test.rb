require "test_helper"

class Storefront::ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @shop = shops(:one)
    @product = products(:blue_dream)
  end

  test "shows product" do
    host! @shop.domain
    get "/product/#{@product.slug}/"
    assert_response :success
    assert_includes response.body, @product.name
    assert_includes response.body, "application/ld+json"
  end

  test "returns 404 for missing product" do
    host! @shop.domain
    get "/product/nonexistent-product/"
    assert_response :not_found
  end

  test "returns 404 when shop not found" do
    host! "unknown.test"
    get "/product/#{@product.slug}/"
    assert_response :not_found
  end

  test "does not return product from other shop" do
    host! shops(:two).domain
    get "/product/#{@product.slug}/"
    assert_response :not_found
  end

  test "redirects to trailing slash" do
    host! @shop.domain
    get "/product/#{@product.slug}"
    assert_redirected_to "/product/#{@product.slug}/"
    assert_response :moved_permanently
  end
end
