class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  validates :name, presence: true

  def enabled_items
    items.where(status: "enabled")
  end

  def disabled_items
    items.where(status: "disabled")
  end

  def enabled_merchant
    where(status: "enabled")
  end

  def disabled_merchant
    where(status: "disabled")
  end
end
