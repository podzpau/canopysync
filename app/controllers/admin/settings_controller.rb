class Admin::SettingsController < AdminController
  def edit
    @shop = Shop.find_by(domain: 'alpaca.club')
  end

  def update
    @shop = Shop.find_by(domain: 'alpaca.club')
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
      :font_family, :custom_font_url
    )
  end
end