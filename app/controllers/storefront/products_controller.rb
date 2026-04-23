module Storefront
  class ProductsController < BaseController
    def show
      @product = Current.shop.products.includes(:brand).find_by!(slug: params[:slug])
    end
  end
end
