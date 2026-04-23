module Storefront
  class StrainsController < BaseController
    def index
      @strains = Current.shop.strains.where(noindex: false).order(:name)
      set_seo_meta(
        description: "Browse cannabis strains available at #{Current.shop.name}",
        canonical: "https://#{request.host}/strains/"
      )
    end

    def show
      @strain = Current.shop.strains.find_by!(slug: params[:slug])
      @products = Current.shop.products.where(published: true)
                       .where("strain_classification = ? OR name ILIKE ?", @strain.classification, "%#{@strain.name}%")
                       .includes(:brand).limit(50)
      title = @strain.seo_title.presence || "#{@strain.name} Strain - #{Current.shop.name}"
      desc = @strain.seo_description.presence || "Shop #{@strain.name} products at #{Current.shop.name}"
      set_seo_meta(description: desc, canonical: "https://#{request.host}/strains/#{@strain.slug}/")
      @noindex = true if @strain.noindex?
    end
  end
end
