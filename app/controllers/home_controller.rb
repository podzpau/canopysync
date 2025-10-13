class HomeController < ApplicationController
  def index
    @shop = Shop.first || Shop.create!(
      name: "CanopySync Demo",
      domain: request.host
    )
  end
end
