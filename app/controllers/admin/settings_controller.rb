class Admin::SettingsController < ApplicationController
  def edit
    @shop = Shop.first || Shop.create!(name: "CanopySync Demo")
  end

  def update
    @shop = Shop.first
    if @shop.update(shop_params)
      redirect_to edit_admin_settings_path, notice: 'Settings updated'
    else
      render :edit
    end
  end

  def preview
    @shop = Shop.first || Shop.create!(name: "CanopySync Demo")
    render layout: 'preview'
  end

  private

  def shop_params
    params.require(:shop).permit(:name, :domain, :primary_color, :secondary_color, :font_family, :logo_url, :corner_style, :meta_title, :meta_description)
  end
end