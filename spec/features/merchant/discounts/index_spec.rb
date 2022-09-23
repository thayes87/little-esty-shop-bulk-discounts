require 'rails_helper'

RSpec.describe 'Merchant Bulk Discount Index Page' do
  describe 'As a merchant' do
    describe 'When I visit my merchant items index page' do
      it 'I see a link to view all my discounts, When I click this link, Then I am taken to my bulk discounts index page' do
        @merchant_1 = Merchant.create!(name: "Tom's Hat Shop")
        @merchant_2 = Merchant.create!(name: "Em's Shoe Barn")

        @discount_a = BulkDiscount.create!(description: "discount A", quantity_break: 5, discount: 10, merchant_id: @merchant_1.id)
        @discount_b = BulkDiscount.create!(description: "discount B", quantity_break: 10, discount: 15, merchant_id: @merchant_1.id)
        @discount_c = BulkDiscount.create!(description: "discount C", quantity_break: 5, discount: 10, merchant_id: @merchant_2.id)
        @discount_d = BulkDiscount.create!(description: "discount D", quantity_break: 10, discount: 15, merchant_id: @merchant_2.id)
        
        visit merchant_items_path(@merchant_1)

        expect(page).to have_link("Bulk Discounts")
        click_link("Discounts")

        expect(current_path).to eq(merchant_discounts_path(@merchant_1))
      end

      it 'Then I am taken to my bulk discounts index page, Where I see all of my bulk discounts including their percentage discount and quantity thresholds' do
        visit merchant_discounts_path(@merchant_1)

        within "div#bulk_discounts_a" do
          expect(page).to have_content("Discount A: 10%")
          expect(page).to have_content("Quantity Break: 5 Items")
          expect(page).to_not have_content("Discount B: 15%")
          expect(page).to_not have_content("Quantity Break: 10 Items")
        end
        
        within "div#bulk_discounts_b" do
          expect(page).to have_content("Discount B: 15%")
          expect(page).to have_content("Quantity Break: 10 Items")
          expect(page).to_not have_content("Discount A: 10%")
          expect(page).to_not have_content("Quantity Break: 5 Items")
        end
      end

      it 'each bulk discount listed includes a link to its show page' do
        visit merchant_discounts_path(@merchant_1)
        
        within "div#bulk_discounts_a" do
          expect(page).to have_link("Discount A")
          expect(page).to_not have_link("Discount B")
        end
        
        within "div#bulk_discounts_a" do
          expect(page).to have_link("Discount B")
          expect(page).to_not have_link("Discount A")
        end
      end
    end
  end
end
