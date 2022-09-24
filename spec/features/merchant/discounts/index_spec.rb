require 'rails_helper'

RSpec.describe 'Merchant Bulk Discount Index Page' do
  describe 'As a merchant' do
    describe 'When I visit my merchant items index page' do
      it 'I see a link to view all my discounts, When I click this link, Then I am taken to my bulk discounts index page' do
        @merchant_1 = Merchant.create!(name: "Tom's Hat Shop")
        @merchant_2 = Merchant.create!(name: "Em's Shoe Barn")

        @discount_a = BulkDiscount.create!(description: "A", quantity_break: 5, discount: 10, merchant_id: @merchant_1.id)
        @discount_b = BulkDiscount.create!(description: "B", quantity_break: 10, discount: 15, merchant_id: @merchant_1.id)
        @discount_c = BulkDiscount.create!(description: "C", quantity_break: 5, discount: 10, merchant_id: @merchant_2.id)
        @discount_d = BulkDiscount.create!(description: "D", quantity_break: 10, discount: 15, merchant_id: @merchant_2.id)
        
        visit merchant_dashboard_index_path(@merchant_1)

        expect(page).to have_link("Bulk Discounts")
        click_link("Bulk Discounts")

        expect(current_path).to eq(merchant_bulk_discounts_path(@merchant_1))
      end

      it 'Then I am taken to my bulk discounts index page, Where I see all of my bulk discounts including their percentage discount and quantity thresholds' do
        @merchant_1 = Merchant.create!(name: "Tom's Hat Shop")
        @merchant_2 = Merchant.create!(name: "Em's Shoe Barn")

        @discount_a = BulkDiscount.create!(description: "A", quantity_break: 5, discount: 10, merchant_id: @merchant_1.id)
        @discount_b = BulkDiscount.create!(description: "B", quantity_break: 10, discount: 15, merchant_id: @merchant_1.id)
        @discount_c = BulkDiscount.create!(description: "C", quantity_break: 5, discount: 10, merchant_id: @merchant_2.id)
        @discount_d = BulkDiscount.create!(description: "D", quantity_break: 10, discount: 15, merchant_id: @merchant_2.id)
        
        visit merchant_bulk_discounts_path(@merchant_1)

        within "div#bulk_discounts_A" do
          expect(page).to have_content("Discount: 10%")
          expect(page).to have_content("Quantity Break: 5 items")
          expect(page).to_not have_content("Discount: 15%")
          expect(page).to_not have_content("Quantity Break: 10 items")
        end
        
        within "div#bulk_discounts_B" do
          expect(page).to have_content("Discount: 15%")
          expect(page).to have_content("Quantity Break: 10 items")
          expect(page).to_not have_content("Discount: 10%")
          expect(page).to_not have_content("Quantity Break: 5 items")
        end
      end

      it 'each bulk discount listed includes a link to its show page' do
        @merchant_1 = Merchant.create!(name: "Tom's Hat Shop")
        @merchant_2 = Merchant.create!(name: "Em's Shoe Barn")

        @discount_a = BulkDiscount.create!(description: "A", quantity_break: 5, discount: 10, merchant_id: @merchant_1.id)
        @discount_b = BulkDiscount.create!(description: "B", quantity_break: 10, discount: 15, merchant_id: @merchant_1.id)
        @discount_c = BulkDiscount.create!(description: "C", quantity_break: 5, discount: 10, merchant_id: @merchant_2.id)
        @discount_d = BulkDiscount.create!(description: "D", quantity_break: 10, discount: 15, merchant_id: @merchant_2.id)
        
        visit merchant_bulk_discounts_path(@merchant_1)
        
        within "div#bulk_discounts_A" do
          expect(page).to have_link("Discount A")
          expect(page).to_not have_link("Discount B")
        end
        
        within "div#bulk_discounts_B" do
          expect(page).to have_link("Discount B")
          expect(page).to_not have_link("Discount A")
        end
      end

      it 'I see a link to create a new discount, When I click this link I am taken to a new page where I see a form to add a new bulk discount ' do 
        @merchant_2 = Merchant.create!(name: "Em's Shoe Barn")
        
        visit merchant_bulk_discounts_path(@merchant_2)

        expect(page).to have_link("Create Discount")

        click_link("Create Discount")

        expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant_2))
      end

      it 'When I fill in the form with valid data and hit sumbit, I am redirected back to the bulk discount index' do
        @merchant_2 = Merchant.create!(name: "Em's Shoe Barn")
        
        visit new_merchant_bulk_discount_path(@merchant_2)

        fill_in('Description', with: 'D')
        fill_in('Quantity Break', with: '25')
        fill_in('Discount', with: 25)
        click_button('Submit')

        expect(current_path).to eq(merchant_bulk_discounts_path(@merchant_2))
      end
    end
  end
end
