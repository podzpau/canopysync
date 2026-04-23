class Brand < ApplicationRecord
  include Sluggable
  include SeoScorable

  belongs_to :shop
  has_many :products, dependent: :nullify

  after_commit :touch_shop_sitemap

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: { scope: :shop_id }
  validates :meadow_id, uniqueness: { scope: :shop_id, allow_nil: true }

  private

  def seo_has_image?
    logo_url.present?
  end

  def touch_shop_sitemap
    shop.update_column(:sitemap_updated_at, Time.current)
  end
end
