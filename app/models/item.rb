class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true
  validates :merchant_id, presence: true
  validates :status, presence: true


  def self.ready_to_ship(merchant_id)
    select(:id, :name, "invoice_items.invoice_id as invoice_id", "invoices.created_at as invoice_date")
    .joins(:invoices, :invoice_items)
    .distinct
    .where(merchant_id: merchant_id)
    .where("invoice_items.status != 2")
    .where("invoices.status = 0")
    .order("invoice_date")
  end

  def total_revenue_generated
    invoice_items.sum do |invoice_item|
      (invoice_item.quantity * invoice_item.unit_price)
    end
  end
end
