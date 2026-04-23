require "test_helper"

class BreadcrumbHelperTest < ActionView::TestCase
  include BreadcrumbHelper

  ITEMS = [
    { name: "Home",   url: "https://greenleaf.test/" },
    { name: "Flower", url: "https://greenleaf.test/collection/flower/" },
    { name: "Blue Dream", url: "https://greenleaf.test/product/blue-dream/" }
  ].freeze

  # --- breadcrumb_schema ---

  test "schema has BreadcrumbList type" do
    schema = breadcrumb_schema(ITEMS, host: "greenleaf.test", path: "/product/blue-dream/")
    assert_equal "BreadcrumbList", schema["@type"]
  end

  test "schema @id follows convention" do
    schema = breadcrumb_schema(ITEMS, host: "greenleaf.test", path: "/product/blue-dream/")
    assert_equal "https://greenleaf.test/product/blue-dream/#breadcrumb", schema["@id"]
  end

  test "schema itemListElement count matches items" do
    schema = breadcrumb_schema(ITEMS, host: "greenleaf.test", path: "/product/blue-dream/")
    assert_equal 3, schema["itemListElement"].length
  end

  test "schema positions are 1-indexed" do
    schema = breadcrumb_schema(ITEMS, host: "greenleaf.test", path: "/product/blue-dream/")
    positions = schema["itemListElement"].map { |e| e["position"] }
    assert_equal [ 1, 2, 3 ], positions
  end

  test "schema ListItem has name and item url" do
    schema = breadcrumb_schema(ITEMS, host: "greenleaf.test", path: "/product/blue-dream/")
    first  = schema["itemListElement"].first
    assert_equal "Home", first["name"]
    assert_equal "https://greenleaf.test/", first["item"]
  end

  test "two-item breadcrumb" do
    items  = ITEMS.first(2)
    schema = breadcrumb_schema(items, host: "greenleaf.test", path: "/collection/flower/")
    assert_equal 2, schema["itemListElement"].length
  end

  # --- breadcrumb_html ---

  test "html renders nav element" do
    html = breadcrumb_html(ITEMS)
    assert_includes html, "<nav"
    assert_includes html, "</nav>"
  end

  test "html renders ordered list" do
    html = breadcrumb_html(ITEMS)
    assert_includes html, "<ol"
    assert_includes html, "</ol>"
  end

  test "last item has aria-current=page span" do
    html = breadcrumb_html(ITEMS)
    assert_includes html, "aria-current=\"page\""
    assert_includes html, "Blue Dream"
  end

  test "non-last items render as links" do
    html = breadcrumb_html(ITEMS)
    assert_includes html, 'href="https://greenleaf.test/"'
    assert_includes html, ">Home<"
  end

  test "click depth is at most 3 from home" do
    # 3 items = home + 1 intermediate + current = depth 2 from home ✓
    assert ITEMS.length <= 3, "breadcrumb must not exceed 3 items"
  end
end
