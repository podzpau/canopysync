module Storefront
  class BaseController < ActionController::Base
    protect_from_forgery with: :exception
    layout "storefront"
    helper :all

    before_action :enforce_trailing_slash
    before_action :resolve_shop
    before_action :check_redirects
    before_action :set_noindex_flag

    NOINDEX_PATH_PREFIXES = %w[/cart /checkout /login /account /search].freeze

    private

    def enforce_trailing_slash
      original_path = request.env["REQUEST_URI"]&.split("?")&.first || request.path
      return if original_path.end_with?("/")
      return if original_path.match?(/\.\w{2,4}\z/)

      destination = request.query_string.present? ? "#{request.path}/?#{request.query_string}" : "#{request.path}/"
      redirect_to destination, status: :moved_permanently
    end

    def resolve_shop
      Current.shop = Shop.find_by(domain: request.host)
      head :not_found unless Current.shop
    end

    def set_noindex_flag
      path = request.path

      if NOINDEX_PATH_PREFIXES.any? { |prefix| path == prefix || path.start_with?("#{prefix}/") }
        @noindex = true
        return
      end

      if path.start_with?("/collection/") && request.query_string.present?
        @noindex = true
        @noindex_canonical = "https://#{request.host}#{path}/"
      end

      record = @product || @brand || @collection
      @noindex = true if record.respond_to?(:noindex) && record.noindex
    end

    def check_redirects
      return unless Current.shop
      redirect_record = Current.shop.redirects.active.find_by(source_path: request.path)
      if redirect_record
        redirect_record.increment!(:hits)
        redirect_to redirect_record.target_path, status: redirect_record.redirect_type
      end
    end
  end
end
