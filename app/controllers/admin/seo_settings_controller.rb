class Admin::SeoSettingsController < AdminController
  def edit
    @shop = @current_admin.shop
  end

  def update
    @shop = @current_admin.shop
    if @shop.update(seo_settings_params)
      redirect_to edit_admin_seo_settings_path, notice: "Global SEO settings saved."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def seo_settings_params
    params.require(:shop).permit(
      :default_seo_title_suffix,
      :default_meta_description,
      :seo_homepage_title,
      :seo_homepage_description,
      :google_analytics_id,
      :google_search_console_verification,
      :social_facebook_url,
      :social_instagram_url,
      :social_twitter_url,
      :social_linkedin_url,
      :social_youtube_url,
      :html_sitemap_enabled,
      :custom_robots_txt
    )
  end
end
