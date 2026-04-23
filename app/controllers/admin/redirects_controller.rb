class Admin::RedirectsController < AdminController
  before_action :set_redirect, only: [ :edit, :update, :destroy ]

  def index
    @redirects = @current_admin.shop.redirects.order(created_at: :desc)
  end

  def new
    @redirect = @current_admin.shop.redirects.new(redirect_type: 301)
  end

  def create
    @redirect = @current_admin.shop.redirects.new(redirect_params)
    if @redirect.save
      redirect_to admin_redirects_path, notice: "Redirect created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @redirect.update(redirect_params)
      redirect_to admin_redirects_path, notice: "Redirect updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @redirect.destroy
    redirect_to admin_redirects_path, notice: "Redirect deleted."
  end

  private

  def set_redirect
    @redirect = @current_admin.shop.redirects.find(params[:id])
  end

  def redirect_params
    params.require(:redirect).permit(:source_path, :target_path, :redirect_type, :active)
  end
end
