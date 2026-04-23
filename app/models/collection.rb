class Collection < ApplicationRecord
  include Sluggable
  include SeoScorable

  COLLECTION_TYPES = %w[category facet].freeze

  belongs_to :shop
  belongs_to :parent, class_name: "Collection", optional: true
  has_many :children, class_name: "Collection", foreign_key: :parent_id, dependent: :destroy

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: { scope: [ :shop_id, :parent_id ] }
  validates :collection_type, presence: true, inclusion: { in: COLLECTION_TYPES }

  after_commit :touch_shop_sitemap

  scope :roots, -> { where(parent_id: nil) }
  scope :published, -> { where(published: true) }

  private

  def touch_shop_sitemap
    shop.update_column(:sitemap_updated_at, Time.current)
  end
end
