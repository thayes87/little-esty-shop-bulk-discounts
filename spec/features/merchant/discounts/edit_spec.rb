require 'rails_helper'

RSpec.describe 'Merchant Bulk Discount Edit' do
  describe 'As a merchant' do
    describe 'As a merchant When I visit my bulk discount show page' do
      it 'I see a link to edit the bulk discount, When I click, I am taken to a new page with a form to edit the discount ' do
        @merchant_1 = Merchant.create!(name: "Tom's Hat Shop")

        @discount_a = BulkDiscount.create!(description: "A", quantity_break: 5, discount: 10, merchant_id: @merchant_1.id)
        
        visit merchant_bulk_discount_path(@merchant_1, @discount_a)

        expect(page).to have_link("Edit")
        click_link("Edit")

        expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant_1, @discount_a))
      end

      it 'When I change any/all of the information and click submit, I am redirected to the bulk discount\'s show page' do
        #happy path 
        @merchant_1 = Merchant.create!(name: "Tom's Hat Shop")

        @discount_a = BulkDiscount.create!(description: "A", quantity_break: 5, discount: 10, merchant_id: @merchant_1.id)
        
        visit edit_merchant_bulk_discount_path(@merchant_1, @discount_a)

        fill_in 'Description', with: "F"
        fill_in 'Quantity Break', with: '20'
        fill_in 'Discount', with: '25'
        click_button 'Save'

        expect(current_path).to eq(merchant_bulk_discount_path(@merchant_1, @discount_a))

        expect(page).to have_content("Discount: 25%")
        expect(page).to have_content("Quantity Break: 20 items")
        expect(page).to_not have_content("Discount: 10%")
        expect(page).to_not have_content("Quantity Break: 5 items")

        expect(page).to have_content("Bulk Discount Successfully Updated")
      end
      
      it 'When I change any/all of the information and click submit, I am redirected to the bulk discount\'s show page' do
        #sad path
        @merchant_1 = Merchant.create!(name: "Tom's Hat Shop")

        @discount_a = BulkDiscount.create!(description: "A", quantity_break: 5, discount: 10, merchant_id: @merchant_1.id)
        
        visit edit_merchant_bulk_discount_path(@merchant_1, @discount_a)

        fill_in 'Description', with: ""
        fill_in 'Quantity Break', with: '20'
        fill_in 'Discount', with: '25'
        click_button 'Save'

        expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant_1, @discount_a))

        expect(page).to have_content("Bulk Discount NOT Successfully Updated, Additional Information Required")
      end
    end
  end
end 