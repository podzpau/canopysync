require "test_helper"

class Admin::DashboardControllerTest < ActionDispatch::IntegrationTest
  setup do
    @shop  = shops(:one)
    @admin = admin_users(:one)
    host! @shop.domain
    post admin_login_path, params: { email: @admin.email, password: "password" }
  end

  test "shows dashboard for authenticated admin" do
    get admin_dashboard_path
    assert_response :success
  end

  test "unauthenticated request redirects to login" do
    delete admin_logout_path
    get admin_dashboard_path
    assert_redirected_to admin_login_path
  end

  test "renders metrics in response" do
    get admin_dashboard_path
    assert_response :success
    assert_includes response.body, "Sales Overview"
    assert_includes response.body, "Revenue"
  end

  test "default period renders today" do
    get admin_dashboard_path
    assert_response :success
    assert_includes response.body, "today"
  end

  test "accepts valid period param" do
    get admin_dashboard_path, params: { period: "month" }
    assert_response :success
    assert_includes response.body, "month"
  end

  test "ignores invalid period param and defaults to today" do
    get admin_dashboard_path, params: { period: "decade" }
    assert_response :success
    assert_includes response.body, "today"
  end

  test "cross-tenant admin cannot access dashboard" do
    host! shops(:two).domain
    get admin_dashboard_path
    assert_redirected_to admin_login_path
  end
end
