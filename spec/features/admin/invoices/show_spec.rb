require 'rails_helper'

RSpec.describe 'As an admin,' do
  describe "When I visit an admin invoice show page" do
    it "Then I see information related to that invoice including:
      - Invoice id
      - Invoice status
      - Invoice created_at date in the format 'Monday, July 18, 2019'
      - Customer first and last name" do

      visit admin_invoice_path(Invoice.first)

      expect(page).to have_content("Invoice ID: 1")
      expect(page).to have_content("Invoice ID: 1")
      expect(page).to have_content("cancelled")
      expect(page).to have_content("Created at: Sunday, March 25, 2012")
      expect(page).to have_content("Customer: Joey Ondricka")

      expect(page).to_not have_content("Cecelia Osinski")
      expect(page).to_not have_content("Invoice ID: 2")
    end

    it "Then I see all of the items on the invoice including:
      - Item name
      - The quantity of the item ordered
      - The price the Item sold for
      - The Invoice Item status" do

      visit admin_invoice_path(Invoice.first)
      # save_and_open_page
      expect(page).to have_content("Invoice Items")
      expect(page).to have_content("Item Qui Esse")
      expect(page).to have_content("Quantity: 5")
      expect(page).to have_content("Unit Price: $751.07")
      expect(page).to have_content("Status: shipped")

      expect(page).not_to have_content("Item Eos Quia")
      expect(page).not_to have_content("Packaged")
    end
  end
end
