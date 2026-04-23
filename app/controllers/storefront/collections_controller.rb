module Storefront
  class CollectionsController < BaseController
    def show
      segments = params[:path].split("/").reject(&:blank?)
      raise ActionController::RoutingError, "Not Found" if segments.empty?

      collection = nil
      segments.each do |segment|
        collection = Current.shop.collections.find_by!(slug: segment, parent: collection)
      end
      @collection = Current.shop.collections.includes(:parent).find(collection.id)
      @products   = Current.shop.products.where(published: true).includes(:brand).limit(50)
    end
  end
end
