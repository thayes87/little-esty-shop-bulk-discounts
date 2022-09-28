require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many(:items) }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:bulk_discounts) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'instance methods' do
    describe '.enabled_items' do
      it 'returns a list of all the items that are enabled for a specific merchant' do
        merchant = Merchant.first
        expect(merchant.enabled_items.count).to eq(0)

        merchant.items.first.update(status: "enabled")
        expect(merchant.enabled_items.count).to eq(1)
      end
    end

    describe '.disabled_items' do
      it 'returns a list of all the items that are disabled for a specific merchant' do
        merchant = Merchant.first
        expect(merchant.disabled_items.count).to eq(3)

        merchant.items.first.update(status: "enabled")
        expect(merchant.disabled_items.count).to eq(2)
      end
    end

    describe "top_five_by_revenue" do
      it "returns the top five merchants by revenue" do
        klein = Merchant.find(2)
        schroeder = Merchant.find(1)
        willms = Merchant.find(3)
        cummings = Merchant.find(4)
        williamson = Merchant.find(6)

        expected_arr = [klein, schroeder, willms, cummings, williamson]

        expect(Merchant.top_five_by_revenue).to eq(expected_arr)
      end
    end

    describe "best_day" do
      it "Returns the date of a merchants best day by revenue" do
        klein = Merchant.find(2)
        schroeder = Merchant.find(1)
        willms = Merchant.find(3)
        cummings = Merchant.find(4)
        williamson = Merchant.find(6)

        expect(klein.best_day).to eq "2012-03-25 09:54:09"
        expect(schroeder.best_day).to eq "2012-03-25 09:54:09"
        expect(willms.best_day).to eq "2012-03-07 19:54:10"
        expect(cummings.best_day).to eq "2012-03-12 05:54:09"
        expect(williamson.best_day).to eq "2012-03-10 00:54:09"
      end
    end

    describe ".single_discount?" do
      it "returns true if a merchant has ONLY one bulk_discount" do
        @merchant1 = Merchant.create!(id: 45, name:"Bob's Baskets")
        @discount_a = BulkDiscount.create!(description: "A", quantity_break: 10, discount: 25, merchant_id: @merchant1.id)

        expect(@merchant1.single_discount?).to eq(true)
      end

      it 'returns false if a merchant has MORE than one bulk_discount' do
        @merchant1 = Merchant.create!(id: 45, name:"Bob's Baskets")
        @discount_a = BulkDiscount.create!(description: "A", quantity_break: 10, discount: 25, merchant_id: @merchant1.id)
        @discount_b = BulkDiscount.create!(description: "B", quantity_break: 15, discount: 35, merchant_id: @merchant1.id)

        expect(@merchant1.single_discount?).to eq(false)
      end
    end
    
    describe ".multiple_discounts?" do
      it "returns false if a merchant has ONLY one bulk_discount" do
        @merchant1 = Merchant.create!(id: 45, name:"Bob's Baskets")
        @discount_a = BulkDiscount.create!(description: "A", quantity_break: 10, discount: 25, merchant_id: @merchant1.id)

        expect(@merchant1.multiple_discounts?).to eq(false)
      end

      it "returns true if a merchant has MORE than one bulk_discount" do
        @merchant1 = Merchant.create!(id: 45, name:"Bob's Baskets")
        @discount_a = BulkDiscount.create!(description: "A", quantity_break: 10, discount: 25, merchant_id: @merchant1.id)
        @discount_b = BulkDiscount.create!(description: "B", quantity_break: 15, discount: 35, merchant_id: @merchant1.id)
        
        expect(@merchant1.multiple_discounts?).to eq(true)
      end
    end

    describe ".sorted_bulk_discounts" do
      it "returns a all bulk_discounts for a merchant in ascending order base on quantity_break" do
        @merchant1 = Merchant.create!(id: 45, name:"Bob's Baskets")
        @discount_a = BulkDiscount.create!(description: "A", quantity_break: 25, discount: 50, merchant_id: @merchant1.id)
        @discount_b = BulkDiscount.create!(description: "B", quantity_break: 10, discount: 35, merchant_id: @merchant1.id)
        @discount_c = BulkDiscount.create!(description: "C", quantity_break: 15, discount: 45, merchant_id: @merchant1.id)
        
        expect(@merchant1.sorted_bulk_discounts).to eq([@discount_b, @discount_c, @discount_a])
      end
    end
  end
end
