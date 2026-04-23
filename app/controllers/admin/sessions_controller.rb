class Admin::SessionsController < ApplicationController
  layout "admin"

  def new
  end

  def create
    user = AdminUser.find_by(email: params[:email]&.strip&.downcase)
    if user&.authenticate(params[:password]) && user.shop_id == @shop&.id
      session[:admin_user_id] = user.id
      redirect_to admin_dashboard_path
    else
      flash.now[:alert] = "Invalid email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:admin_user_id)
    redirect_to admin_login_path
  end
end
