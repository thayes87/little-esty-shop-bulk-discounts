class AddBulkDiscountIdToInvoiceItems < ActiveRecord::Migration[5.2]
  def change
    add_reference :invoice_items, :bulk_discounts, foreign_key: true  
  end
end
