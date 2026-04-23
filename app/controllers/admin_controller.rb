class AdminController < ApplicationController
  layout "admin"

  before_action :require_authentication

  helper_method :current_admin

  private

  def set_shop
    super
    redirect_to admin_login_path unless @shop
  end

  def require_authentication
    @current_admin = AdminUser.find_by(id: session[:admin_user_id])
    unless @current_admin && @current_admin.shop_id == @shop&.id
      redirect_to admin_login_path
    end
  end

  def current_admin
    @current_admin
  end
end
