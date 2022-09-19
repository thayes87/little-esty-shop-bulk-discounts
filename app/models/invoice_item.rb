class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice

  validates :item_id, presence: true
  validates :invoice_id, presence: true
  validates :quantity, presence: true
  validates :unit_price, presence: true
  validates :status, presence: true
  enum status: [ :pending, :packaged, :shipped]

  def self.for_merchant(merchant_id)
    select(:item_id, :status, :unit_price, :quantity)
      .joins(item: [:invoice_items])
      .where("items.merchant_id = #{merchant_id}")
  end
end
