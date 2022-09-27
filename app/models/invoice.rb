class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :bulk_discounts, through: :merchant
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions

  validates :customer_id, presence: true
  validates :status, presence: true
  enum status: [ :in_progress, :completed, :cancelled]

  def self.not_shipped_invoices
    joins(:invoice_items, :customer).where('invoice_items.status != 2').order(:created_at)
  end

  def total_revenue
    invoice_items.sum('invoice_items.quantity * invoice_items.unit_price')
  end

  def merchant_single_discountable_items(merchant) 
    invoice_items.where("quantity >= ?", merchant.bulk_discounts.first.quantity_break)
  end

  def merchant_single_non_discountable_items(merchant)
    invoice_items.where("quantity < ?", merchant.bulk_discounts.first.quantity_break)
  end
  
  def collect_item_information(merchant)
    if merchant.single_discount? && merchant_single_discountable_items(merchant).present?
      discount_revenue = merchant_single_discountable_items(merchant).sum('quantity * unit_price') * (1 - (merchant.bulk_discounts.first.discount.to_f / 100))
      non_discounted_revenue = merchant_single_non_discountable_items(merchant).sum('quantity * unit_price').to_f
      merchant_single_discountable_items(merchant).update(bulk_discounts_id: merchant.bulk_discounts.first.id)
      bulk_discount_revenue = discount_revenue + non_discounted_revenue
    elsif merchant.bulk_discounts.count > 1 && merchant.bulk_discounts.pluck(:quantity_break).any? { |qty_break| qty_break >= invoice_items.pluck(:quantity).min }
      discounted_revenue_by_item = {}
      invoice_items.each do |invoice_item|
        merchant.bulk_discounts.order(quantity_break: :asc).each do |bulk_discount|
          next unless invoice_item.quantity >= bulk_discount.quantity_break
          discount_price = (bulk_discount.discount.to_f / 100) * (invoice_item.quantity * invoice_item.unit_price)
          discounted_revenue_by_item[invoice_item.id] = discount_price
          invoice_item.update(bulk_discounts_id: bulk_discount.id)
        end
      end
      bulk_discount_revenue = total_revenue - discounted_revenue_by_item.values.sum
    else
      bulk_discount_revenue = total_revenue
    end
  end
end
