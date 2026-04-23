class Order < ApplicationRecord
  belongs_to :shop
  has_many :order_items, dependent: :destroy

  validates :ordered_at, presence: true

  scope :completed, -> { where(status: "completed") }
  scope :in_period, ->(period) {
    case period
    when "today" then where(ordered_at: Time.current.beginning_of_day..)
    when "week"  then where(ordered_at: 1.week.ago.beginning_of_day..)
    when "month" then where(ordered_at: 1.month.ago.beginning_of_day..)
    else               where(ordered_at: Time.current.beginning_of_day..)
    end
  }
end
