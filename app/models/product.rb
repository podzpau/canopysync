class Product < ApplicationRecord
  include Sluggable
  include SeoScorable

  PRODUCT_TYPES = %w[flower pre-roll edible concentrate vape tincture topical beverage capsule].freeze
  STRAIN_CLASSIFICATIONS = %w[sativa indica hybrid].freeze

  belongs_to :shop
  belongs_to :brand, optional: true
  belongs_to :strain, optional: true, primary_key: :name, foreign_key: :strain_name

  after_commit :touch_shop_sitemap

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: { scope: :shop_id }
  validates :product_type, presence: true, inclusion: { in: PRODUCT_TYPES }
  validates :strain_classification, inclusion: { in: STRAIN_CLASSIFICATIONS }, allow_nil: true
  validates :meadow_id, uniqueness: { scope: :shop_id, allow_nil: true }

  private

  def seo_has_image?
    image_url.present?
  end

  def touch_shop_sitemap
    shop.update_column(:sitemap_updated_at, Time.current)
  end

  def compute_slug
    if strain_name.present?
      if product_type == "flower"
        strain_name.parameterize
      else
        "#{strain_name} #{product_type}".parameterize
      end
    else
      name.to_s.parameterize
    end
  end
end
