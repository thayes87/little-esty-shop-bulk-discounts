require 'rails_helper'

RSpec.describe 'Merchant Bulk Discount Show Page' do
  describe 'As a merchant' do
    describe 'When I visit my merchant items show page' do
      it 'Then I see the bulk discount\'s quantity threshold and percentage discount' do
        visit merchant_discount_path(Merchant.first, XXX)

        expect(page).to have_content("Discount A: 10%")
        expect(page).to have_content("Quantity Break: 5 Items")

        expect(page).to_not have_content("Discount B: 15%")
        expect(page).to_not have_content("Quantity Break: 10 Items")
      end
    end
  end
end
