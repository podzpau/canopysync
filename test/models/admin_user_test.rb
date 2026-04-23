require "test_helper"

class AdminUserTest < ActiveSupport::TestCase
  def valid_admin
    AdminUser.new(email: "new@example.com", password: "password123", shop: shops(:one))
  end

  test "valid admin user" do
    assert valid_admin.valid?
  end

  test "requires email" do
    admin = valid_admin
    admin.email = nil
    assert_not admin.valid?
    assert_includes admin.errors[:email], "can't be blank"
  end

  test "requires password" do
    admin = AdminUser.new(email: "new@example.com", shop: shops(:one))
    assert_not admin.valid?
  end

  test "requires shop" do
    admin = AdminUser.new(email: "new@example.com", password: "password123")
    assert_not admin.valid?
  end

  test "validates email format - rejects missing domain" do
    admin = valid_admin
    admin.email = "notanemail"
    assert_not admin.valid?
    assert admin.errors[:email].any?
  end

  test "validates email format - rejects missing tld" do
    admin = valid_admin
    admin.email = "user@domain"
    assert_not admin.valid?
  end

  test "accepts valid email" do
    admin = valid_admin
    admin.email = "user@domain.com"
    assert admin.valid?
  end

  test "enforces unique email" do
    duplicate = valid_admin
    duplicate.email = admin_users(:one).email
    assert_not duplicate.valid?
    assert duplicate.errors[:email].any?
  end

  test "unique email check is case-insensitive" do
    duplicate = valid_admin
    duplicate.email = admin_users(:one).email.upcase
    assert_not duplicate.valid?
  end

  test "downcases email before save" do
    admin = valid_admin
    admin.email = "UPPER@EXAMPLE.COM"
    admin.save!
    assert_equal "upper@example.com", admin.reload.email
  end

  test "authenticates with correct password" do
    assert admin_users(:one).authenticate("password")
  end

  test "rejects wrong password" do
    assert_not admin_users(:one).authenticate("wrongpassword")
  end

  test "belongs to shop" do
    assert_equal shops(:one), admin_users(:one).shop
  end
end
