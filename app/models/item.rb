class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true
  validates :merchant_id, presence: true


  def self.ready_to_ship(merchant_id)
      joins(:invoice_items, :invoices)
      .distinct
      .where.not('invoice_items.status = 2')
      .where('invoices.status = 0')
      .where(merchant_id: merchant_id)
  end
end
