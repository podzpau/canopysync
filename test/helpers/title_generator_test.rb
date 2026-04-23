require "test_helper"

class TitleGeneratorTest < ActiveSupport::TestCase
  # Lightweight structs for unit testing without hitting the DB
  Product = Struct.new(:strain_name, :product_type, :name, :brand, keyword_init: true)
  Brand   = Struct.new(:name, keyword_init: true)
  Collection = Struct.new(:name, :parent, keyword_init: true)

  # --- product ---

  test "flower with brand" do
    b = Brand.new(name: "Cannabis Co")
    p = Product.new(strain_name: "Blue Dream", product_type: "flower", name: "Blue Dream", brand: b)
    assert_equal "Blue Dream Weed Strain | Cannabis Co", TitleGenerator.product(p)
  end

  test "flower without brand" do
    p = Product.new(strain_name: "Blue Dream", product_type: "flower", name: "Blue Dream", brand: nil)
    assert_equal "Blue Dream Weed Strain", TitleGenerator.product(p)
  end

  test "pre-roll strain with brand uses en dash" do
    b = Brand.new(name: "Brand X")
    p = Product.new(strain_name: "Blue Dream", product_type: "pre-roll", name: "BD Pre-Roll", brand: b)
    assert_equal "Blue Dream Weed Strain \u2013 Pre-Roll | Brand X", TitleGenerator.product(p)
  end

  test "non-flower strain product" do
    b = Brand.new(name: "Co")
    p = Product.new(strain_name: "OG Kush", product_type: "vape", name: "OG Vape", brand: b)
    assert_equal "OG Kush Weed Strain \u2013 Vape | Co", TitleGenerator.product(p)
  end

  test "non-strain product without brand" do
    p = Product.new(strain_name: nil, product_type: "edible", name: "CBD Gummies", brand: nil)
    assert_equal "CBD Gummies", TitleGenerator.product(p)
  end

  test "non-strain product with brand" do
    b = Brand.new(name: "Wyld")
    p = Product.new(strain_name: nil, product_type: "edible", name: "CBD Gummies", brand: b)
    assert_equal "CBD Gummies | Wyld", TitleGenerator.product(p)
  end

  test "caps at 65 characters" do
    b = Brand.new(name: "A Very Long Brand Name That Goes On Forever And Ever")
    p = Product.new(strain_name: "Grand Daddy Purple", product_type: "flower", name: "GDP", brand: b)
    result = TitleGenerator.product(p)
    assert result.length <= 65
  end

  # --- collection ---

  test "root category gets Cannabis prefix" do
    c = Collection.new(name: "Flower", parent: nil)
    assert_equal "Buy Cannabis Flower", TitleGenerator.collection(c)
  end

  test "root edibles category" do
    c = Collection.new(name: "Edibles", parent: nil)
    assert_equal "Buy Cannabis Edibles", TitleGenerator.collection(c)
  end

  test "sativa facet under flower" do
    parent = Collection.new(name: "Flower", parent: nil)
    c = Collection.new(name: "Sativa", parent: parent)
    assert_equal "Buy Sativa Flower", TitleGenerator.collection(c)
  end

  test "indica facet under flower" do
    parent = Collection.new(name: "Flower", parent: nil)
    c = Collection.new(name: "Indica", parent: parent)
    assert_equal "Buy Indica Flower", TitleGenerator.collection(c)
  end

  test "non-dominance subtype facet" do
    parent = Collection.new(name: "Edibles", parent: nil)
    c = Collection.new(name: "Gummies", parent: parent)
    assert_equal "Buy Cannabis Gummies", TitleGenerator.collection(c)
  end

  test "collection title caps at 65" do
    c = Collection.new(name: "Very Long Category Name That Exceeds The Limit Significantly", parent: nil)
    assert TitleGenerator.collection(c).length <= 65
  end

  # --- brand ---

  test "brand with no product type returns generic" do
    b = Brand.new(name: "STIIIZY")
    assert_equal "Buy STIIIZY Cannabis Products", TitleGenerator.brand(b, product_type: nil)
  end

  test "brand with flower type" do
    b = Brand.new(name: "Garden")
    assert_equal "Buy Garden Flower", TitleGenerator.brand(b, product_type: "flower")
  end

  test "brand with edible type" do
    b = Brand.new(name: "Wyld")
    assert_equal "Buy Wyld Edibles", TitleGenerator.brand(b, product_type: "edible")
  end

  test "brand name already contains product type token - avoids duplication" do
    b = Brand.new(name: "Flower House")
    assert_equal "Buy Flower House Cannabis Products", TitleGenerator.brand(b, product_type: "flower")
  end

  test "brand name contains pre-roll token" do
    b = Brand.new(name: "Roll'd Up Co")
    assert_equal "Buy Roll'd Up Co Cannabis Products", TitleGenerator.brand(b, product_type: "pre-roll")
  end

  test "brand preserves official casing" do
    b = Brand.new(name: "STIIIZY")
    assert_equal "Buy STIIIZY Vapes", TitleGenerator.brand(b, product_type: "vape")
  end

  test "brand title caps at 65" do
    b = Brand.new(name: "A Very Long Brand Name That Goes On And On And On")
    result = TitleGenerator.brand(b, product_type: "edible")
    assert result.length <= 65
  end
end
