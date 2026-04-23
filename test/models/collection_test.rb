require "test_helper"

class CollectionTest < ActiveSupport::TestCase
  test "valid with required fields" do
    collection = Collection.new(shop: shops(:two), name: "Test", collection_type: "category")
    assert collection.valid?
  end

  test "requires name" do
    collection = Collection.new(shop: shops(:one), collection_type: "category")
    assert_not collection.valid?
    assert_includes collection.errors[:name], "can't be blank"
  end

  test "requires collection_type" do
    collection = Collection.new(shop: shops(:one), name: "Test")
    assert_not collection.valid?
    assert_includes collection.errors[:collection_type], "can't be blank"
  end

  test "validates collection_type inclusion" do
    collection = Collection.new(shop: shops(:one), name: "Test", collection_type: "invalid")
    assert_not collection.valid?
    assert_includes collection.errors[:collection_type], "is not included in the list"
  end

  test "slug unique per shop and parent" do
    dupe = Collection.new(shop: shops(:one), name: "Flower", slug: "flower", collection_type: "category", parent: nil)
    assert_not dupe.valid?
    assert_includes dupe.errors[:slug], "has already been taken"
  end

  test "allows same slug under different parent" do
    collection = Collection.new(shop: shops(:one), name: "Sativa", slug: "sativa", collection_type: "facet", parent: nil)
    assert collection.valid?
  end

  test "allows same slug in different shop" do
    collection = Collection.new(shop: shops(:two), name: "Flower", slug: "flower", collection_type: "category")
    assert collection.valid?
  end

  test "auto-generates slug from name" do
    collection = Collection.new(shop: shops(:two), name: "Indica Strains", collection_type: "facet")
    collection.valid?
    assert_equal "indica-strains", collection.slug
  end

  test "parent-child hierarchy" do
    parent = collections(:flower)
    child = collections(:sativa)
    assert_equal parent, child.parent
    assert_includes parent.children, child
  end

  test "root collections have no parent" do
    assert_nil collections(:flower).parent
  end

  test "children destroyed with parent" do
    parent_id = collections(:flower).id
    child_id = collections(:sativa).id
    collections(:flower).destroy
    assert_not Collection.exists?(child_id)
  end
end
