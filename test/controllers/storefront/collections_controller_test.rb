require "test_helper"

class Storefront::CollectionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @shop = shops(:one)
  end

  test "shows root collection" do
    host! @shop.domain
    get "/collection/flower/"
    assert_response :success
    assert_includes response.body, collections(:flower).name
    assert_includes response.body, "application/ld+json"
  end

  test "shows nested collection" do
    host! @shop.domain
    get "/collection/flower/sativa/"
    assert_response :success
    assert_includes response.body, collections(:sativa).name
  end

  test "returns 404 for missing collection" do
    host! @shop.domain
    get "/collection/nonexistent/"
    assert_response :not_found
  end

  test "returns 404 when child not found under parent" do
    host! @shop.domain
    get "/collection/flower/nonexistent/"
    assert_response :not_found
  end

  test "returns 404 when shop not found" do
    host! "unknown.test"
    get "/collection/flower/"
    assert_response :not_found
  end

  test "redirects root path to trailing slash" do
    host! @shop.domain
    get "/collection/flower"
    assert_redirected_to "/collection/flower/"
    assert_response :moved_permanently
  end

  test "redirects nested path to trailing slash" do
    host! @shop.domain
    get "/collection/flower/sativa"
    assert_redirected_to "/collection/flower/sativa/"
    assert_response :moved_permanently
  end
end
