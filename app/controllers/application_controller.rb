class ApplicationController < ActionController::Base
  before_action :set_shop

  private

  def set_shop
    @shop = Shop.find_by(domain: request.host)
    @shop ||= Shop.first if Rails.env.development?
  end
end
