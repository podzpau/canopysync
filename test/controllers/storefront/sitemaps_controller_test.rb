require "test_helper"

class Storefront::SitemapsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @shop = shops(:one)
    host! @shop.domain
  end

  # --- sitemap index ---

  test "sitemap index returns xml" do
    get "/sitemap.xml"
    assert_response :success
    assert_equal "application/xml", response.media_type
  end

  test "sitemap index contains sitemapindex root" do
    get "/sitemap.xml"
    assert_includes response.body, "<sitemapindex"
  end

  test "sitemap index includes products segment" do
    get "/sitemap.xml"
    assert_includes response.body, "sitemap-products.xml"
  end

  test "sitemap index includes collections segment when collections exist" do
    get "/sitemap.xml"
    assert_includes response.body, "sitemap-collections.xml"
  end

  test "sitemap index includes brands segment when brands exist" do
    get "/sitemap.xml"
    assert_includes response.body, "sitemap-brands.xml"
  end

  test "sitemap index returns 404 when shop not found" do
    host! "unknown.test"
    get "/sitemap.xml"
    assert_response :not_found
  end

  # --- products sitemap ---

  test "products sitemap returns xml" do
    get "/sitemap-products.xml"
    assert_response :success
    assert_equal "application/xml", response.media_type
  end

  test "products sitemap contains urlset" do
    get "/sitemap-products.xml"
    assert_includes response.body, "<urlset"
  end

  test "products sitemap includes product URLs" do
    get "/sitemap-products.xml"
    assert_includes response.body, "/product/blue-dream/"
  end

  test "products sitemap page 2 returns xml" do
    get "/sitemap-products-2.xml"
    assert_response :success
  end

  # --- collections sitemap ---

  test "collections sitemap returns xml" do
    get "/sitemap-collections.xml"
    assert_response :success
    assert_equal "application/xml", response.media_type
  end

  test "collections sitemap includes collection URLs" do
    get "/sitemap-collections.xml"
    assert_includes response.body, "/collection/flower/"
  end

  test "nested collection URL includes parent slug" do
    get "/sitemap-collections.xml"
    assert_includes response.body, "/collection/flower/sativa/"
  end

  # --- brands sitemap ---

  test "brands sitemap returns xml" do
    get "/sitemap-brands.xml"
    assert_response :success
    assert_equal "application/xml", response.media_type
  end

  test "brands sitemap includes brand URLs" do
    get "/sitemap-brands.xml"
    assert_includes response.body, "/brand/cannabis-co/"
  end

  # --- images sitemap ---

  test "images sitemap returns xml" do
    get "/sitemap-images.xml"
    assert_response :success
    assert_equal "application/xml", response.media_type
  end

  test "images sitemap contains image namespace" do
    get "/sitemap-images.xml"
    assert_includes response.body, "sitemap-image"
  end

  # --- html sitemap ---

  test "html sitemap returns success" do
    get "/sitemap"
    assert_response :success
  end

  test "html sitemap includes collection links" do
    get "/sitemap"
    assert_includes response.body, "/collection/flower/"
  end

  test "html sitemap includes brand links" do
    get "/sitemap"
    assert_includes response.body, "/brand/cannabis-co/"
  end

  test "html sitemap does not redirect to trailing slash" do
    get "/sitemap"
    assert_response :success
  end
end
