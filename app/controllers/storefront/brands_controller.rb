module Storefront
  class BrandsController < BaseController
    def show
      @brand    = Current.shop.brands.find_by!(slug: params[:slug])
      @products = @brand.products.where(published: true).includes(:brand).limit(50)
      product_types = @products.map(&:product_type).uniq
      @effective_product_type = product_types.one? ? product_types.first : nil
    end
  end
end
