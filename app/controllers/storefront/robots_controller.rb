module Storefront
  class RobotsController < BaseController
    skip_before_action :enforce_trailing_slash

    def show
      render :show, layout: false, content_type: "text/plain"
    end
  end
end
