require "test_helper"

class Admin::AuthenticationTest < ActionDispatch::IntegrationTest
  test "unauthenticated request to settings redirects to login" do
    host! shops(:one).domain
    get edit_admin_settings_path
    assert_redirected_to admin_login_path
  end

  test "authenticated admin can access settings" do
    host! shops(:one).domain
    post admin_login_path, params: { email: admin_users(:one).email, password: "password" }
    get edit_admin_settings_path
    assert_response :success
  end

  test "admin for shop one cannot access shop two admin panel" do
    # Authenticate as shop one's admin
    host! shops(:one).domain
    post admin_login_path, params: { email: admin_users(:one).email, password: "password" }
    assert session[:admin_user_id] == admin_users(:one).id

    # Switch host to shop two — same session cookie, different tenant
    host! shops(:two).domain
    get edit_admin_settings_path
    assert_redirected_to admin_login_path
  end

  test "admin for shop two cannot access shop one admin panel" do
    host! shops(:two).domain
    post admin_login_path, params: { email: admin_users(:two).email, password: "password" }
    assert session[:admin_user_id] == admin_users(:two).id

    host! shops(:one).domain
    get edit_admin_settings_path
    assert_redirected_to admin_login_path
  end

  test "login page accessible without authentication" do
    host! shops(:one).domain
    get admin_login_path
    assert_response :success
  end

  test "cross-tenant login rejected at login form" do
    # Shop two admin tries to log into shop one's domain
    host! shops(:one).domain
    post admin_login_path, params: { email: admin_users(:two).email, password: "password" }
    assert_response :unprocessable_entity
    assert_nil session[:admin_user_id]
  end
end
