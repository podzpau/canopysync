module Sluggable
  extend ActiveSupport::Concern

  included do
    before_validation :generate_slug, if: -> { slug.blank? }
  end

  private

  def generate_slug
    self.slug = compute_slug
  end

  def compute_slug
    name.to_s.parameterize
  end
end
