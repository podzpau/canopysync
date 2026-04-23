require "test_helper"

class OrderTest < ActiveSupport::TestCase
  test "completed scope excludes pending orders" do
    assert_not_includes Order.completed.to_a, orders(:pending_order)
  end

  test "completed scope includes completed orders" do
    assert_includes Order.completed.to_a, orders(:one)
    assert_includes Order.completed.to_a, orders(:two)
  end

  test "in_period today includes orders from today" do
    shop_orders = shops(:one).orders
    assert_includes shop_orders.in_period("today"), orders(:one)
    assert_includes shop_orders.in_period("today"), orders(:two)
  end

  test "in_period today excludes old orders" do
    assert_not_includes shops(:one).orders.in_period("today"), orders(:old)
  end

  test "in_period week includes recent orders" do
    assert_includes shops(:one).orders.in_period("week"), orders(:one)
  end

  test "in_period week excludes two-month-old orders" do
    assert_not_includes shops(:one).orders.in_period("week"), orders(:old)
  end

  test "in_period month includes recent orders" do
    assert_includes shops(:one).orders.in_period("month"), orders(:one)
  end

  test "in_period month excludes two-month-old orders" do
    assert_not_includes shops(:one).orders.in_period("month"), orders(:old)
  end

  test "in_period unknown defaults to today" do
    shop_orders = shops(:one).orders
    assert_includes shop_orders.in_period("bogus"), orders(:one)
    assert_not_includes shop_orders.in_period("bogus"), orders(:old)
  end
end
