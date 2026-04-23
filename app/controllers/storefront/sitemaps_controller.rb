module Storefront
  class SitemapsController < BaseController
    skip_before_action :enforce_trailing_slash
    layout false

    PRODUCTS_PER_PAGE = 200

    def index
      shop = Current.shop
      @segments = []

      products_count = shop.products.where(published: true).count
      products_pages = (products_count.to_f / PRODUCTS_PER_PAGE).ceil.clamp(1, Float::INFINITY).to_i
      products_pages.times do |i|
        page = i + 1
        filename = page == 1 ? "sitemap-products.xml" : "sitemap-products-#{page}.xml"
        @segments << { loc: "https://#{request.host}/#{filename}", lastmod: shop.sitemap_updated_at || shop.updated_at }
      end

      if shop.collections.where(published: true).exists?
        @segments << { loc: "https://#{request.host}/sitemap-collections.xml", lastmod: shop.sitemap_updated_at || shop.updated_at }
      end

      if shop.brands.exists?
        @segments << { loc: "https://#{request.host}/sitemap-brands.xml", lastmod: shop.sitemap_updated_at || shop.updated_at }
      end

      if shop.products.where(published: true, image_url: nil).count < shop.products.where(published: true).count
        @segments << { loc: "https://#{request.host}/sitemap-images.xml", lastmod: shop.sitemap_updated_at || shop.updated_at }
      end

      if shop.strains.where(noindex: false).exists?
        @segments << { loc: "https://#{request.host}/sitemap-strains.xml", lastmod: shop.sitemap_updated_at || shop.updated_at }
      end

      render :index
    end

    def products
      page = (params[:page] || 1).to_i
      offset = (page - 1) * PRODUCTS_PER_PAGE
      @products = Current.shop.products.where(published: true).order(:slug).offset(offset).limit(PRODUCTS_PER_PAGE)
      render :products
    end

    def collections
      @collections = Current.shop.collections.where(published: true).includes(:parent).order(:parent_id, :position)
      render :collections
    end

    def brands
      @brands = Current.shop.brands.order(:name)
      render :brands
    end

    def images
      @products = Current.shop.products.where(published: true).where.not(image_url: nil).order(:slug)
      render :images
    end

    def strains
      @strains = Current.shop.strains.where(noindex: false).order(:name)
      render :strains
    end

    def html_sitemap
      return render plain: "Not found", status: :not_found unless Current.shop.html_sitemap_enabled?
      @collections = Current.shop.collections.where(published: true).includes(:parent).order(:parent_id, :position)
      @brands = Current.shop.brands.order(:name)
      render layout: "storefront"
    end
  end
end
