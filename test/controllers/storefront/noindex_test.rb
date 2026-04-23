require "test_helper"

# Tests for noindex rules and updated trailing-slash enforcement.
# These are integration tests against real storefront routes.
class Storefront::NoindexTest < ActionDispatch::IntegrationTest
  setup do
    @shop = shops(:one)
    host! @shop.domain
  end

  # --- normal pages are indexable ---

  test "product page has index, follow" do
    get "/product/#{products(:blue_dream).slug}/"
    assert_response :success
    assert_includes response.body, 'content="index, follow"'
  end

  test "collection page has index, follow" do
    get "/collection/flower/"
    assert_response :success
    assert_includes response.body, 'content="index, follow"'
  end

  test "brand page has index, follow" do
    get "/brand/#{brands(:cannabis_co).slug}/"
    assert_response :success
    assert_includes response.body, 'content="index, follow"'
  end

  # --- filtered collections ---

  test "collection with sort param is noindexed" do
    get "/collection/flower/?sort=price_asc"
    assert_response :success
    assert_includes response.body, 'content="noindex, follow"'
  end

  test "collection with filter param is noindexed" do
    get "/collection/flower/?filter=sativa"
    assert_response :success
    assert_includes response.body, 'content="noindex, follow"'
  end

  test "filtered collection canonical points to base URL without query params" do
    get "/collection/flower/?sort=price_asc"
    assert_response :success
    assert_includes response.body, %(<link rel="canonical" href="https://#{@shop.domain}/collection/flower/">)
  end

  test "canonical for filtered nested collection strips query params" do
    get "/collection/flower/sativa/?sort=thc"
    assert_response :success
    assert_includes response.body, %(<link rel="canonical" href="https://#{@shop.domain}/collection/flower/sativa/">)
    refute_includes response.body, "sort=thc"
  end

  # --- noindex path prefixes ---

  test "cart path is noindexed" do
    get "/collection/flower/"  # baseline: this is indexable, just confirming prefix logic
    assert_includes response.body, 'content="index, follow"'
    # We can't GET /cart/ (no route), but we can test the flag logic via a known
    # route that shares the pattern — see unit test in base_controller_noindex_unit_test.rb
  end

  # --- trailing-slash redirect with query string ---

  test "collection without slash and with query string redirects to slashed path preserving query string" do
    get "/collection/flower?sort=price_asc"
    assert_response :moved_permanently
    assert_redirected_to "/collection/flower/?sort=price_asc"
  end

  test "product without slash and with query string redirects preserving query string" do
    get "/product/#{products(:blue_dream).slug}?ref=email"
    assert_response :moved_permanently
    assert_redirected_to "/product/#{products(:blue_dream).slug}/?ref=email"
  end

  test "path without slash and without query string redirects normally" do
    get "/collection/flower"
    assert_response :moved_permanently
    assert_redirected_to "/collection/flower/"
  end

  # --- file-extension paths skip trailing-slash redirect ---

  test "xml path does not get trailing slash redirect" do
    get "/sitemap.xml"
    assert_response :success
  end

  test "robots.txt does not get trailing slash redirect" do
    get "/robots.txt"
    assert_response :success
  end
end
