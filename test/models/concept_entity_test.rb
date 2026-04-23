require "test_helper"

class ConceptEntityTest < ActiveSupport::TestCase
  test "valid with required fields" do
    entity = ConceptEntity.new(key: "test_entity", name: "Test Entity")
    assert entity.valid?
  end

  test "requires key" do
    entity = ConceptEntity.new(name: "Test")
    assert_not entity.valid?
    assert_includes entity.errors[:key], "can't be blank"
  end

  test "requires name" do
    entity = ConceptEntity.new(key: "test_key")
    assert_not entity.valid?
    assert_includes entity.errors[:name], "can't be blank"
  end

  test "key must be unique" do
    entity = ConceptEntity.new(key: "cannabis_flower", name: "Duplicate")
    assert_not entity.valid?
    assert_includes entity.errors[:key], "has already been taken"
  end

  test "allows optional wikipedia and wikidata urls" do
    entity = ConceptEntity.new(
      key: "new_entity",
      name: "New Entity",
      wikipedia_url: "https://en.wikipedia.org/wiki/Cannabis",
      wikidata_url: "https://www.wikidata.org/wiki/Q79"
    )
    assert entity.valid?
  end
end
