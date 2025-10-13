class ApplicationController < ActionController::Base
  before_action :set_shop

  private

  def set_shop
    # For now, just get the first shop
    # Later you'll match by domain
    @shop = Shop.first || Shop.create!(name: "Default Shop", domain: request.host)
  end
end
