class Customer < ApplicationRecord
  has_many :invoices
  has_many :transactions, through: :invoices
  has_many :invoice_items, through: :invoices
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  validates :first_name, presence: true
  validates :last_name, presence: true


  def self.top_five_customers(merchant_id = false)
    if merchant_id
      select(:id, :first_name, :last_name, 'count(transactions.*) as number_transactions')
      .joins(invoices: [:transactions, :items])
      .where('transactions.result = 0')
      .where('items.merchant_id = ?', merchant_id)
      .group(:id)
      .order('number_transactions desc')
      .limit(5)
    else
      select(:id, :first_name, :last_name, 'count(transactions.*) as number_transactions')
      .joins(:transactions)
      .where('transactions.result = 0')
      .group(:id)
      .order('number_transactions desc')
      .limit(5)
    end
  end
end
