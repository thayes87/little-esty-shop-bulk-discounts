require 'rails_helper'

RSpec.describe 'merchant items show page' do
  describe 'as a merchant, when I click on the name of an item from the merchant items index page' do
    it 'I am taken to that merchants items show page' do 
      # visit merchant_items_path
      # visit "/merchants/#{Merchant.first.id}/items"

      # expect(page).to have_link("Item Qui Esse")
      # click_link("Item Qui Esse")
      visit "/merchants/#{Merchant.first.id}/items/#{Item.find_by(name: "Item Qui Esse").id}"
      
      expect(page).to have_content("Item Qui Esse")
      expect(page).to have_content("Nihil autem sit odio inventore deleniti. Est lauda")
      expect(page).to have_content("$751.07")
    end
  end
end

# Merchant Items Show Page

# As a merchant,
# When I click on the name of an item from the merchant items index page,
# Then I am taken to that merchant's item's show page (/merchants/merchant_id/items/item_id)
# And I see all of the item's attributes including:

# Name
# Description
# Current Selling Price