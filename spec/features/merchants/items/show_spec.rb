require 'rails_helper'

RSpec.describe 'merchant items show page' do
  describe 'as a merchant, when I click on the name of an item from the merchant items index page' do
    it 'I am taken to that merchants items show page' do

      # visit "/merchants/#{Merchant.first.id}/items"

      # expect(page).to have_link("Item Qui Esse")
      # click_link("Item Qui Esse")

      visit merchant_item_path(1, 1)
      expect(page).to have_content("Item Qui Esse")
      expect(page).to have_content("Nihil autem sit odio inventore deleniti. Est lauda")
      expect(page).to have_content("$751.07")
    end
  end

  describe 'When I visit the merchant show page of an item' do
    it 'I see a link to update the item information' do
      visit merchant_item_path(1, 1)

      expect(page).to have_link("Update Item")

      click_link("Update Item")

      expect(current_path).to eq(edit_merchant_item(1, 1))
      #how do I test the preexisting data has been added to the update form? 
      fill_in 'name', with: "Item A"
      fill_in 'description', with: 'Description A'
      fill_in 'unit_price', with '95487'
      click_button 'Submit'

      expect(current-path).to eq(merchant_item_path(1, 1))
      expect(page).to have content("Item A")
      expect(page).to have content("Description A")
      expect(page).to have content("95487")
      #do we need to test a flash message since it is being handled by the framework? 
      expect(controller).to set_flash[:updated]
    end
  end
end


# As a merchant,
# When I visit the merchant show page of an item
# I see a link to update the item information.
# When I click the link
# Then I am taken to a page to edit this item
# And I see a form filled in with the existing item attribute information
# When I update the information in the form and I click ‘submit’
# Then I am redirected back to the item show page where I see the updated information
# And I see a flash message stating that the information has been successfully updated.
