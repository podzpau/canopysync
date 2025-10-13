class AdminController < ApplicationController
  # Add authentication later
  layout "admin"

  private

  def current_shop
    @shop
  end
end
