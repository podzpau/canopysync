class Block < ApplicationRecord
  acts_as_list scope: :shop_id
  belongs_to :shop
end