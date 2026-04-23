class Strain < ApplicationRecord
  belongs_to :shop
  has_many :products, primary_key: :name, foreign_key: :strain_name

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: { scope: :shop_id }

  CLASSIFICATIONS = %w[sativa indica hybrid].freeze
  validates :classification, inclusion: { in: CLASSIFICATIONS }, allow_nil: true

  before_validation :generate_slug, if: -> { slug.blank? && name.present? }

  private

  def generate_slug
    self.slug = name.parameterize
  end
end
