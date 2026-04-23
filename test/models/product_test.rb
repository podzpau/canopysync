require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "valid with required fields" do
    product = Product.new(shop: shops(:two), name: "Test Product", product_type: "edible")
    assert product.valid?
  end

  test "requires name" do
    product = Product.new(shop: shops(:one), product_type: "edible")
    assert_not product.valid?
    assert_includes product.errors[:name], "can't be blank"
  end

  test "requires product_type" do
    product = Product.new(shop: shops(:one), name: "Test")
    assert_not product.valid?
    assert_includes product.errors[:product_type], "can't be blank"
  end

  test "validates product_type inclusion" do
    product = Product.new(shop: shops(:one), name: "Test", product_type: "invalid_type")
    assert_not product.valid?
    assert_includes product.errors[:product_type], "is not included in the list"
  end

  test "validates strain_classification inclusion" do
    product = Product.new(shop: shops(:one), name: "Test", product_type: "flower", strain_classification: "ruderalis")
    assert_not product.valid?
    assert_includes product.errors[:strain_classification], "is not included in the list"
  end

  test "allows nil strain_classification" do
    product = Product.new(shop: shops(:two), name: "Test", product_type: "edible")
    assert product.valid?
  end

  test "slug unique per shop" do
    product = Product.new(shop: shops(:one), name: "Blue Dream", slug: "blue-dream", product_type: "edible")
    assert_not product.valid?
    assert_includes product.errors[:slug], "has already been taken"
  end

  test "allows same slug in different shop" do
    product = Product.new(shop: shops(:two), name: "Blue Dream", slug: "blue-dream", product_type: "flower")
    assert product.valid?
  end

  test "flower slug uses strain name" do
    product = Product.new(shop: shops(:two), name: "Blue Dream Flower", product_type: "flower", strain_name: "Blue Dream")
    product.valid?
    assert_equal "blue-dream", product.slug
  end

  test "non-flower strain slug uses strain name and type" do
    product = Product.new(shop: shops(:two), name: "BD Pre-Roll", product_type: "pre-roll", strain_name: "Blue Dream")
    product.valid?
    assert_equal "blue-dream-pre-roll", product.slug
  end

  test "non-strain product slug uses name" do
    product = Product.new(shop: shops(:two), name: "CBD Gummy Bears", product_type: "edible")
    product.valid?
    assert_equal "cbd-gummy-bears", product.slug
  end

  test "does not overwrite existing slug" do
    product = Product.new(shop: shops(:two), name: "Blue Dream", product_type: "flower", strain_name: "Blue Dream", slug: "custom-slug")
    product.valid?
    assert_equal "custom-slug", product.slug
  end

  test "meadow_id unique per shop" do
    products(:blue_dream).update!(meadow_id: "p-abc")
    product = Product.new(shop: shops(:one), name: "Other", product_type: "edible", meadow_id: "p-abc")
    assert_not product.valid?
  end

  test "allows same meadow_id in different shop" do
    products(:blue_dream).update!(meadow_id: "p-abc")
    product = Product.new(shop: shops(:two), name: "Other", product_type: "edible", meadow_id: "p-abc")
    assert product.valid?
  end
end
