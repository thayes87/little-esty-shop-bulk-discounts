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
  
  describe '.bulk_discount_revenue' do
    it "Should return the total invoice revenue for ALL items when a merchant has NO applicable discounts" do
#example #1
      @merchant1 = Merchant.create!(id: 45, name:"Bob's Baskets")
      @discount_a = BulkDiscount.create!(description: "A", quantity_break: 10, discount: 25, merchant_id: @merchant1.id)   
      @customer1 = Customer.create!(id: 45, first_name:"John", last_name:"Doe") 
      @item1 = Item.create!(id: 45, name:"Big basket", description:"Green and big", unit_price: 1499, merchant_id: @merchant1.id)
      @item2 = Item.create!(id: 46, name:"Medium basket", description:"Blue and medium", unit_price: 1399, merchant_id: @merchant1.id)
      @invoice1 = Invoice.create!(id: 45, customer_id: @customer1.id, status: 1)
      @invoice_item1 = InvoiceItem.create!(id: 45, item_id: @item1.id, invoice_id: @invoice1.id, quantity: 5, unit_price:1499 , status: 0)
      @invoice_item2 = InvoiceItem.create!(id: 46, item_id: @item2.id, invoice_id: @invoice1.id, quantity: 5, unit_price:1399 , status: 1)

      expect(@invoice1.bulk_discount_revenue(@merchant1)).to eq(14490)
    end
  end
  
  describe '.bulk_discount_revenue' do
    it "Should return the total discounted invoice revenue for ALL items when a merchant has a single applicable discount" do
#example #2
      @merchant1 = Merchant.create!(id: 45, name:"Bob's Baskets")
      @discount_a = BulkDiscount.create!(description: "A", quantity_break: 10, discount: 25, merchant_id: @merchant1.id)   
      @customer1 = Customer.create!(id: 45, first_name:"John", last_name:"Doe") 
      @item1 = Item.create!(id: 45, name:"Big basket", description:"Green and big", unit_price: 1499, merchant_id: @merchant1.id)
      @item2 = Item.create!(id: 46, name:"Medium basket", description:"Blue and medium", unit_price: 1399, merchant_id: @merchant1.id)
      @invoice1 = Invoice.create!(id: 45, customer_id: @customer1.id, status: 1)
      @invoice_item1 = InvoiceItem.create!(id: 45, item_id: @item1.id, invoice_id: @invoice1.id, quantity:5, unit_price:1499 , status: 0)
      @invoice_item2 = InvoiceItem.create!(id: 46, item_id: @item2.id, invoice_id: @invoice1.id, quantity:10 , unit_price:1399 , status: 1)

      expect(@invoice1.bulk_discount_revenue(@merchant1)).to eq(17987.5)
    end
  end

  describe '.bulk_discount_revenue' do
    it "Should return the total discounted invoice revenue for ALL items when a merchant has a multiple applicable discounts" do
#exapmle #3
      @merchant1 = Merchant.create!(id: 45, name:"Bob's Baskets")
      @discount_a = BulkDiscount.create!(description: "A", quantity_break: 10, discount: 25, merchant_id: @merchant1.id)
      @discount_b = BulkDiscount.create!(description: "B", quantity_break: 15, discount: 50, merchant_id: @merchant1.id)
      @customer1 = Customer.create!(id: 45, first_name:"John", last_name:"Doe") 
      @item1 = Item.create!(id: 45, name:"Big basket", description:"Green and big", unit_price: 1499, merchant_id: @merchant1.id)
      @item2 = Item.create!(id: 46, name:"Medium basket", description:"Blue and medium", unit_price: 1399, merchant_id: @merchant1.id)
      @invoice1 = Invoice.create!(id: 45, customer_id: @customer1.id, status: 1)
      @invoice_item1 = InvoiceItem.create!(id: 45, item_id: @item1.id, invoice_id: @invoice1.id, quantity: 10, unit_price:1499 , status: 0)
      @invoice_item2 = InvoiceItem.create!(id: 46, item_id: @item2.id, invoice_id: @invoice1.id, quantity: 15, unit_price:1399 , status: 1)

      expect(@invoice1.bulk_discount_revenue(@merchant1)).to eq(21735)
    end
  end

  describe '.bulk_discount_revenue' do
    it "Should return the total discounted invoice revenue for ALL items when a merchant has a multiple applicable discounts" do
#exapmle #4
      @merchant1 = Merchant.create!(id: 45, name:"Bob's Baskets")
      @discount_a = BulkDiscount.create!(description: "A", quantity_break: 10, discount: 20, merchant_id: @merchant1.id)
      @discount_b = BulkDiscount.create!(description: "B", quantity_break: 15, discount: 15, merchant_id: @merchant1.id)
      @customer1 = Customer.create!(id: 45, first_name:"John", last_name:"Doe") 
      @item1 = Item.create!(id: 45, name:"Big basket", description:"Green and big", unit_price: 1499, merchant_id: @merchant1.id)
      @item2 = Item.create!(id: 46, name:"Medium basket", description:"Blue and medium", unit_price: 1399, merchant_id: @merchant1.id)
      @invoice1 = Invoice.create!(id: 45, customer_id: @customer1.id, status: 1)
      @invoice_item1 = InvoiceItem.create!(id: 45, item_id: @item1.id, invoice_id: @invoice1.id, quantity: 12, unit_price:1499 , status: 0)
      @invoice_item2 = InvoiceItem.create!(id: 46, item_id: @item2.id, invoice_id: @invoice1.id, quantity: 15, unit_price:1399 , status: 1)

      expect(@invoice1.bulk_discount_revenue(@merchant1)).to eq(31178.4)
    end
  end

  describe '.bulk_discount_revenue' do
    it "Should return the total discounted invoice revenue for ALL items when a merchant has a multiple applicable discounts" do
#exapmle #5
      merchant1 = Merchant.create!(id: 45, name:"Bob's Baskets")
      merchant2 = Merchant.create!(id: 46, name:"Sue's Shoes")
      discount_a = BulkDiscount.create!(description: "A", quantity_break: 10, discount: 20, merchant_id: merchant1.id)
      discount_b = BulkDiscount.create!(description: "B", quantity_break: 15, discount: 30, merchant_id: merchant1.id)
      customer1 = Customer.create!(id: 45, first_name:"John", last_name:"Doe") 
      item1 = Item.create!(id: 45, name:"Big basket", description:"Green and big", unit_price: 1499, merchant_id: merchant1.id)
      item2 = Item.create!(id: 46, name:"Medium basket", description:"Blue and medium", unit_price: 1399, merchant_id: merchant1.id)
      item3 = Item.create!(id: 47, name:"Sneakers", description:"Red Converse", unit_price: 1299, merchant_id: merchant2.id)
      invoice1 = Invoice.create!(id: 45, customer_id: customer1.id, status: 1)
      invoice_item1 = InvoiceItem.create!(id: 45, item_id: item1.id, invoice_id: invoice1.id, quantity: 12, unit_price:1499 , status: 0)
      invoice_item2 = InvoiceItem.create!(id: 46, item_id: item2.id, invoice_id: invoice1.id, quantity: 15, unit_price:1399 , status: 1)
      invoice_item3 = InvoiceItem.create!(id: 47, item_id: item3.id, invoice_id: invoice1.id, quantity: 15, unit_price:1299 , status: 1)
 
      expect(invoice1.track_multiple_discounts_applied(merchant1)).to eq({invoice_item1.id => 3597.6000000000004, invoice_item2.id => 6295.5})
      expect(invoice1.track_multiple_discounts_applied(merchant2)).to eq({})
    end
  end
end
