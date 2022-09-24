require 'rails_helper'

RSpec.describe 'Merchant Bulk Discount Show Page' do
  describe 'As a merchant' do
    describe 'When I visit my merchant items show page' do
      it 'Then I see the bulk discount\'s quantity threshold and percentage discount' do
        @merchant_1 = Merchant.create!(name: "Tom's Hat Shop")
        @merchant_2 = Merchant.create!(name: "Em's Shoe Barn")

        @discount_a = BulkDiscount.create!(description: "A", quantity_break: 5, discount: 10, merchant_id: @merchant_1.id)
        @discount_b = BulkDiscount.create!(description: "B", quantity_break: 10, discount: 15, merchant_id: @merchant_1.id)
        @discount_c = BulkDiscount.create!(description: "C", quantity_break: 5, discount: 10, merchant_id: @merchant_2.id)
        @discount_d = BulkDiscount.create!(description: "D", quantity_break: 10, discount: 15, merchant_id: @merchant_2.id)

        visit merchant_bulk_discount_path(@merchant_1, @discount_a)

        expect(page).to have_content("Discount: 10%")
        expect(page).to have_content("Quantity Break: 5 items")

        expect(page).to_not have_content("Discount B: 15%")
        expect(page).to_not have_content("Quantity Break: 10 items")
      end
    end
  end
end
