require "test_helper"

class BrandTest < ActiveSupport::TestCase
  test "valid with required fields" do
    brand = Brand.new(shop: shops(:one), name: "Test Brand")
    assert brand.valid?
  end

  test "requires name" do
    brand = Brand.new(shop: shops(:one))
    assert_not brand.valid?
    assert_includes brand.errors[:name], "can't be blank"
  end

  test "requires shop" do
    brand = Brand.new(name: "Test Brand")
    assert_not brand.valid?
  end

  test "requires unique slug per shop" do
    brand = Brand.new(shop: shops(:one), name: "Cannabis Co", slug: "cannabis-co")
    assert_not brand.valid?
    assert_includes brand.errors[:slug], "has already been taken"
  end

  test "allows same slug in different shop" do
    brand = Brand.new(shop: shops(:two), name: "Cannabis Co", slug: "cannabis-co")
    assert brand.valid?
  end

  test "auto-generates slug from name" do
    brand = Brand.new(shop: shops(:two), name: "My Test Brand")
    brand.valid?
    assert_equal "my-test-brand", brand.slug
  end

  test "does not overwrite existing slug" do
    brand = Brand.new(shop: shops(:two), name: "My Test Brand", slug: "custom-slug")
    brand.valid?
    assert_equal "custom-slug", brand.slug
  end

  test "meadow_id unique per shop" do
    brands(:cannabis_co).update!(meadow_id: "m-123")
    brand = Brand.new(shop: shops(:one), name: "Other Brand", meadow_id: "m-123")
    assert_not brand.valid?
    assert_includes brand.errors[:meadow_id], "has already been taken"
  end

  test "allows same meadow_id in different shop" do
    brands(:cannabis_co).update!(meadow_id: "m-123")
    brand = Brand.new(shop: shops(:two), name: "Other Brand", meadow_id: "m-123")
    assert brand.valid?
  end
end
