class Admin::SettingsController < AdminController
  def edit
  end

  def update
    if @shop.update(shop_params)
      redirect_to edit_admin_settings_path, notice: "Settings updated"
    else
      render :edit
    end
  end

  def preview
    render layout: "preview"
  end

  def publish
    @shop = Shop.first
    @shop.publish!
    redirect_to edit_admin_settings_path, notice: 'Site published!'
  end

  def preview_full
    @shop = Shop.first || Shop.create!(name: "CanopySync Demo")
    render template: 'admin/settings/preview', layout: 'preview'
  end

  private

  def shop_params
    params.require(:shop).permit(:name, :domain, :primary_color, :secondary_color, :font_family, :logo_url, :corner_style, :meta_title, :meta_description)
  end
end