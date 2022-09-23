class BulkDiscount < ApplicationRecord
  belongs_to :merchant

  validates :description, presence: true
  validates :quantity_break, presence: true
  validates :discount, presence: true
end