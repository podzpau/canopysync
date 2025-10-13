class Admin::SettingsController < AdminController
  def edit
    @shop = Shop.first || Shop.create!(
      name: "CanopySync Demo",
      domain: request.host
    )
  end

  def update
    @shop = Shop.first
    if @shop.update(shop_params)
      redirect_to edit_admin_settings_path, notice: 'Settings updated successfully'
    else
      render :edit
    end
  end

  private

  def shop_params
    params.require(:shop).permit(
      :name, :domain, :hero_heading, :hero_subheading, 
      :about_text, :primary_color, :secondary_color,
      :font_family, :custom_font_url, :meta_title, 
      :meta_description, :corner_style, :logo_url
    )
  end
end