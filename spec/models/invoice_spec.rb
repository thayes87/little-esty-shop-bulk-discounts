require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { should belong_to(:customer) }
    it { should have_many(:invoice_items) }
    it { should have_many(:transactions) }
    it { should have_many(:items).through (:invoice_items) }
  end

  describe 'validations' do
    it { should validate_presence_of(:customer_id) }
    it { should validate_presence_of(:status) }
  end

  describe '.not_shipped_invoices' do
    it "Should return invoice id's in creation order" do
      invoice_ids = [5, 5, 7, 3, 3, 3, 3, 3, 2, 2, 2, 4, 4, 1, 1, 1, 1, 1]

      expect(Invoice.not_shipped_invoices.ids).to eq invoice_ids
      expect(Invoice.not_shipped_invoices.ids.count).to eq 18
    end
  end

  describe '.total_revenue' do
    it "Should return the total price of all items on an invoice" do
      expect(Invoice.first.total_revenue).to eq(2106777)
    end
  end

  describe '.merchant_single_discountable_items' do
    it "Should return the invoice_items that meet the quantity break for a merchant with a SINGLE discount" do
      
      @merchant1 = Merchant.create!(id: 45, name:"Bob's Baskets")
      @discount_a = BulkDiscount.create!(description: "A", quantity_break: 10, discount: 25, merchant_id: @merchant1.id)   
      @customer1 = Customer.create!(id: 45, first_name:"John", last_name:"Doe") 
      @item1 = Item.create!(id: 45, name:"Big basket", description:"Green and big", unit_price: 1499, merchant_id: @merchant1.id)
      @item2 = Item.create!(id: 46, name:"Medium basket", description:"Blue and medium", unit_price: 1399, merchant_id: @merchant1.id)
      @invoice1 = Invoice.create!(id: 45, customer_id: @customer1.id, status: 1)
      @invoice_item1 = InvoiceItem.create!(id: 45, item_id: @item1.id, invoice_id: @invoice1.id, quantity:5, unit_price:1499 , status: 0)
      @invoice_item2 = InvoiceItem.create!(id: 46, item_id: @item2.id, invoice_id: @invoice1.id, quantity:10 , unit_price:1399 , status: 1)
      
      expect(@invoice1.merchant_single_discountable_items(@merchant1).count).to eq(1)
      expect(@invoice1.merchant_single_discountable_items(@merchant1).first).to eq(@invoice_item2)
    end
  end

  describe '.merchant_single_non_discountable_items' do
    it "Should return the invoice_items that DO NOT meet the quantity break for a merchant with a SINGLE discount" do

      @merchant1 = Merchant.create!(id: 45, name:"Bob's Baskets")
      @discount_a = BulkDiscount.create!(description: "A", quantity_break: 10, discount: 25, merchant_id: @merchant1.id)   
      @customer1 = Customer.create!(id: 45, first_name:"John", last_name:"Doe") 
      @item1 = Item.create!(id: 45, name:"Big basket", description:"Green and big", unit_price: 1499, merchant_id: @merchant1.id)
      @item2 = Item.create!(id: 46, name:"Medium basket", description:"Blue and medium", unit_price: 1399, merchant_id: @merchant1.id)
      @invoice1 = Invoice.create!(id: 45, customer_id: @customer1.id, status: 1)
      @invoice_item1 = InvoiceItem.create!(id: 45, item_id: @item1.id, invoice_id: @invoice1.id, quantity:5, unit_price:1499 , status: 0)
      @invoice_item2 = InvoiceItem.create!(id: 46, item_id: @item2.id, invoice_id: @invoice1.id, quantity:10 , unit_price:1399 , status: 1)

      expect(@invoice1.merchant_single_non_discountable_items(@merchant1).count).to eq(1)
      expect(@invoice1.merchant_single_non_discountable_items(@merchant1).first).to eq(@invoice_item1)
    end
  end

  describe '.calculate_discounted_revenue' do
    it "Should return the total invoice revenue for items that ARE discount elgible" do

      @merchant1 = Merchant.create!(id: 45, name:"Bob's Baskets")
      @discount_a = BulkDiscount.create!(description: "A", quantity_break: 10, discount: 25, merchant_id: @merchant1.id)   
      @customer1 = Customer.create!(id: 45, first_name:"John", last_name:"Doe") 
      @item1 = Item.create!(id: 45, name:"Big basket", description:"Green and big", unit_price: 1499, merchant_id: @merchant1.id)
      @item2 = Item.create!(id: 46, name:"Medium basket", description:"Blue and medium", unit_price: 1399, merchant_id: @merchant1.id)
      @invoice1 = Invoice.create!(id: 45, customer_id: @customer1.id, status: 1)
      @invoice_item1 = InvoiceItem.create!(id: 45, item_id: @item1.id, invoice_id: @invoice1.id, quantity:5, unit_price:1499 , status: 0)
      @invoice_item2 = InvoiceItem.create!(id: 46, item_id: @item2.id, invoice_id: @invoice1.id, quantity:10 , unit_price:1399 , status: 1)

      expect(@invoice1.calculate_discounted_revenue(@merchant1)).to eq(10492.5)
    end
  end

  describe '.calculate_non_discounted_revenue' do
    it "Should return the total invoice revenue for items that ARE NOT discount elgible" do

      @merchant1 = Merchant.create!(id: 45, name:"Bob's Baskets")
      @discount_a = BulkDiscount.create!(description: "A", quantity_break: 10, discount: 25, merchant_id: @merchant1.id)   
      @customer1 = Customer.create!(id: 45, first_name:"John", last_name:"Doe") 
      @item1 = Item.create!(id: 45, name:"Big basket", description:"Green and big", unit_price: 1499, merchant_id: @merchant1.id)
      @item2 = Item.create!(id: 46, name:"Medium basket", description:"Blue and medium", unit_price: 1399, merchant_id: @merchant1.id)
      @invoice1 = Invoice.create!(id: 45, customer_id: @customer1.id, status: 1)
      @invoice_item1 = InvoiceItem.create!(id: 45, item_id: @item1.id, invoice_id: @invoice1.id, quantity:5, unit_price:1499 , status: 0)
      @invoice_item2 = InvoiceItem.create!(id: 46, item_id: @item2.id, invoice_id: @invoice1.id, quantity:10 , unit_price:1399 , status: 1)

      expect(@invoice1.calculate_non_discounted_revenue(@merchant1)).to eq(7495)
    end
  end

  describe '.track_discount_applied' do
    it "Should return the total invoice revenue for items that ARE NOT discount elgible" do

      @merchant1 = Merchant.create!(id: 45, name:"Bob's Baskets")
      @discount_a = BulkDiscount.create!(description: "A", quantity_break: 10, discount: 25, merchant_id: @merchant1.id)   
      @customer1 = Customer.create!(id: 45, first_name:"John", last_name:"Doe") 
      @item1 = Item.create!(id: 45, name:"Big basket", description:"Green and big", unit_price: 1499, merchant_id: @merchant1.id)
      @item2 = Item.create!(id: 46, name:"Medium basket", description:"Blue and medium", unit_price: 1399, merchant_id: @merchant1.id)
      @invoice1 = Invoice.create!(id: 45, customer_id: @customer1.id, status: 1)
      @invoice_item1 = InvoiceItem.create!(id: 45, item_id: @item1.id, invoice_id: @invoice1.id, quantity:5, unit_price:1499 , status: 0)
      @invoice_item2 = InvoiceItem.create!(id: 46, item_id: @item2.id, invoice_id: @invoice1.id, quantity:10 , unit_price:1399 , status: 1)

      expect(@invoice1.track_discount_applied(@merchant1).first.bulk_discounts_id).to eq(@discount_a.id)
    end
  end
end
