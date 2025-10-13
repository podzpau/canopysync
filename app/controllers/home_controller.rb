class HomeController < ApplicationController
  def index
    @shop = Shop.find_by(domain: 'alpaca.club')
  end
end