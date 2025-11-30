class Block < ApplicationRecord
  acts_as_list scope: :shop
  belongs_to :shop
end