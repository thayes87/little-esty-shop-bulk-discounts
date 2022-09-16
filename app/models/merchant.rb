class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  validates :name, presence: true

  def items_ready_to_ship
    items.joins(:invoice_items).where('invoice_items.status = 1').distinct
  end
end
