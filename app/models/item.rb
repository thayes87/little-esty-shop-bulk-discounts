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

  def self.order_by_revenue
    select('items.*, sum(invoice_items.quantity * invoice_items.unit_price) as item_revenue')
    .joins(:invoice_items)
    .group('items.id')
    .order(item_revenue: :desc)
    .limit(5)
  end

  def best_day
    invoices
    .select('invoices.*, count(invoices) as total_invoices')
    .joins(:transactions)
    .where('transactions.result = 0')
    .group('invoices.id')
    .order('total_invoices')
    .last
    .created_at
  end
end
