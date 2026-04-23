require "test_helper"

class SeoSchemaHelperTest < ActionView::TestCase
  include SeoSchemaHelper
  include BreadcrumbHelper

  setup do
    @shop    = shops(:one)
    @product = products(:blue_dream)
    @brand   = brands(:cannabis_co)
    @collection = collections(:flower)
  end

  teardown { Current.reset }

  # helpers need Current.shop set when using the default argument
  def with_shop
    Current.shop = @shop
    yield
  ensure
    Current.reset
  end

  # --- product schemas ---

  test "product_schemas returns two blocks" do
    schemas = product_schemas(@product, shop: @shop)
    assert_equal 2, schemas.length
  end

  test "first block is Product type" do
    schema = product_schemas(@product, shop: @shop).first
    assert_equal "Product", schema["@type"]
    assert_equal "https://schema.org", schema["@context"]
  end

  test "product @id follows convention" do
    schema = product_schemas(@product, shop: @shop).first
    assert_equal "https://#{@shop.domain}/product/#{@product.slug}/#product", schema["@id"]
  end

  test "second block is WebPage type" do
    schema = product_schemas(@product, shop: @shop).last
    assert_equal "WebPage", schema["@type"]
  end

  test "webpage has mainEntity referencing product" do
    schema = product_schemas(@product, shop: @shop).last
    assert_equal "https://#{@shop.domain}/product/#{@product.slug}/#product", schema["mainEntity"]["@id"]
  end

  test "webpage about includes concept nodes with sameAs" do
    # blue_dream is flower/hybrid — resolves cannabis_flower + cannabis_sativa concepts
    schema = product_schemas(@product, shop: @shop).last
    about  = schema["about"]
    assert about.is_a?(Array)
    concept_nodes = about.select { |n| n["@type"] == "Thing" }
    assert concept_nodes.any?, "expected at least one Thing node in about"
    assert concept_nodes.any? { |n| n["sameAs"].present? }, "expected concept nodes to have sameAs"
  end

  test "webpage about includes org node for brand" do
    @product = products(:blue_dream)
    @product.brand = @brand  # ensure brand is set
    schema = product_schemas(@product, shop: @shop).last
    org_nodes = schema["about"].select { |n| n["@type"] == "Organization" }
    assert org_nodes.any?
    assert org_nodes.first["sameAs"].present?
  end

  test "product page total sameAs count >= 3" do
    schemas = product_schemas(products(:blue_dream), shop: @shop)
    assert count_same_as(schemas) >= 3, "expected >= 3 sameAs but got #{count_same_as(schemas)}"
  end

  test "product with price emits offers" do
    @product.price_cents = 2000
    schema = product_schemas(@product, shop: @shop).first
    assert_equal "20.00", schema["offers"]["price"]
    assert_equal "USD", schema["offers"]["priceCurrency"]
  end

  test "product without image omits image key" do
    @product.image_url = nil
    schema = product_schemas(@product, shop: @shop).first
    assert_not schema.key?("image")
  end

  # --- collection schemas ---

  test "collection_schemas returns one block" do
    schemas = collection_schemas(@collection, products: [], shop: @shop)
    assert_equal 1, schemas.length
  end

  test "collection schema is CollectionPage" do
    schema = collection_schemas(@collection, products: [], shop: @shop).first
    assert_equal "CollectionPage", schema["@type"]
  end

  test "collection schema has ItemList mainEntity" do
    prods  = [ products(:blue_dream) ]
    schema = collection_schemas(@collection, products: prods, shop: @shop).first
    assert_equal "ItemList", schema["mainEntity"]["@type"]
    assert_equal 1, schema["mainEntity"]["itemListElement"].length
  end

  test "collection schema about has concept nodes with sameAs" do
    schema = collection_schemas(@collection, products: [], shop: @shop).first
    about  = schema["about"] || []
    assert about.any? { |n| n["sameAs"].present? }, "expected concept nodes with sameAs"
  end

  test "collection page total sameAs count >= 3" do
    schemas = collection_schemas(@collection, products: [], shop: @shop)
    assert count_same_as(schemas) >= 3, "expected >= 3 sameAs but got #{count_same_as(schemas)}"
  end

  test "nested collection path includes parent slug" do
    child  = collections(:sativa)
    schema = collection_schemas(child, products: [], shop: @shop).first
    assert_includes schema["url"], "/collection/flower/sativa/"
  end

  # --- brand schemas ---

  test "brand_schemas returns one block" do
    prods   = Current.shop = @shop and @brand.products.where(published: true).limit(5)
    schemas = brand_schemas(@brand, products: @brand.products.where(published: true), shop: @shop)
    assert_equal 1, schemas.length
  end

  test "brand schema is CollectionPage" do
    schema = brand_schemas(@brand, products: [], shop: @shop).first
    assert_equal "CollectionPage", schema["@type"]
  end

  test "brand schema mainEntity is Brand" do
    schema = brand_schemas(@brand, products: [], shop: @shop).first
    assert_equal "Brand", schema["mainEntity"]["@type"]
  end

  test "brand schema about has org node with sameAs" do
    schema   = brand_schemas(@brand, products: [], shop: @shop).first
    org_node = schema["about"].find { |n| n["@type"] == "Organization" }
    assert org_node, "expected Organization node in about"
    assert org_node["sameAs"].length >= 1
  end

  test "brand page total sameAs count >= 3" do
    prods   = Current.shop.products.where(published: true) rescue @brand.products.where(published: true)
    schemas = brand_schemas(@brand, products: @brand.products.where(published: true), shop: @shop)
    assert count_same_as(schemas) >= 3
  end

  # --- shop org schema ---

  test "shop_org_schema returns Organization with correct @id" do
    schema = shop_org_schema(@shop)
    assert_equal "Organization", schema["@type"]
    assert_equal "https://#{@shop.domain}/#org", schema["@id"]
  end

  private

  def count_same_as(schemas)
    extract_same_as(schemas)
  end

  def extract_same_as(obj)
    case obj
    when Hash
      direct = obj["sameAs"].is_a?(Array) ? obj["sameAs"].length : 0
      direct + obj.values.sum { |v| extract_same_as(v) }
    when Array
      obj.sum { |item| extract_same_as(item) }
    else
      0
    end
  end
end
