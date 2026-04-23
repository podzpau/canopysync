require "test_helper"

class Admin::SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @shop  = shops(:one)
    @admin = admin_users(:one)
    host! @shop.domain
  end

  test "shows login form" do
    get admin_login_path
    assert_response :success
    assert_includes response.body, "Sign in"
  end

  test "logs in with valid credentials" do
    post admin_login_path, params: { email: @admin.email, password: "password" }
    assert_redirected_to admin_dashboard_path
    follow_redirect!
    assert_response :success
  end

  test "sets session on successful login" do
    post admin_login_path, params: { email: @admin.email, password: "password" }
    assert session[:admin_user_id] == @admin.id
  end

  test "rejects wrong password" do
    post admin_login_path, params: { email: @admin.email, password: "wrong" }
    assert_response :unprocessable_entity
    assert_includes response.body, "Invalid email or password"
    assert_nil session[:admin_user_id]
  end

  test "rejects unknown email" do
    post admin_login_path, params: { email: "nobody@example.com", password: "password" }
    assert_response :unprocessable_entity
    assert_nil session[:admin_user_id]
  end

  test "login is case-insensitive for email" do
    post admin_login_path, params: { email: @admin.email.upcase, password: "password" }
    assert_redirected_to admin_dashboard_path
  end

  test "logs out" do
    post admin_login_path, params: { email: @admin.email, password: "password" }
    delete admin_logout_path
    assert_redirected_to admin_login_path
    assert_nil session[:admin_user_id]
  end
end
