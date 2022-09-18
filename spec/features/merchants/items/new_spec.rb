require 'rails_helper'

RSpec.describe 'Merchant item create' do
  describe 'As a merchant' do
    describe 'When I visit my merchant items index page ("merchants/merchant_id/items")' do
      it 'I see a link to create a new item' do
        visit merchant_items_path(Merchant.first)

        expect(page).to have_link("Create Item")
        click_link("Create Item")

        expect(current_path).to eq(new_merchant_item_path(Merchant.first))

        fill_in('Name', with: 'Item A')
        fill_in('Description', with: 'Description A')
        fill_in('Unit Price', with: 9999)
    
        click_button('Save')

        expect(current_path).to eq(merchant_items_path(Merchant.first))

        within "div#Disabled_Items" do
          expect(page).to have_content("Item A")
        end

        within "div#Enabled_Items" do
          expect(page).to_not have_content("Item A")
        end
      end
    end
  end
end
