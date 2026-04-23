class Redirect < ApplicationRecord
  belongs_to :shop

  validates :source_path, presence: true, uniqueness: { scope: :shop_id }
  validates :target_path, presence: true
  validates :redirect_type, inclusion: { in: [ 301, 302 ] }

  scope :active, -> { where(active: true) }

  before_validation :normalize_paths

  private

  def normalize_paths
    self.source_path = source_path.to_s.strip.then { |p| p.start_with?("/") ? p : "/#{p}" }
    self.target_path = target_path.to_s.strip
  end
end
