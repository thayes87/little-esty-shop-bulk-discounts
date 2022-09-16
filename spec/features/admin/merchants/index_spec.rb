require 'rails_helper'

RSpec.describe 'As an admin,' do
  describe 'When I visit the admin Merchants index ("/admin/merchants")' do
    it 'Then I see the name of each merchant in the system' do
      visit admin_merchants_path

      within("#merchant_names") do
        merchant_ids = (1..30).to_a

        expect(page).to have_link("Schroeder-Jerde")
        expect(page).to have_link("Pollich and Koelpin")
        expect(page).to have_link("Jones and Stokes")
        expect(page).to have_link("Ernser, Borer and Marks")

        merchant_ids.each {|id| expect(page.has_css?("##{id}")).to eq true}
      end
    end

    it "When I click on the name of a merchant from the admin merchants index page, I am taken to that merchant's admin show page (/admin/merchants/merchant_id)" do
      visit admin_merchants_path

      within("#merchant_names") do
        expect(page).to have_link("Schroeder-Jerde")
        click_link "Schroeder-Jerde"
        expect(page.current_path).to eq admin_merchant_path("1")

        visit admin_merchants_path

        expect(page).to have_link("Ernser, Borer and Marks")
        click_link "Ernser, Borer and Marks"
        expect(page.current_path).to eq admin_merchant_path("30")
      end
    end

    it "I see the name of that merchant after clicking the merchant link on the index page" do
      visit admin_merchants_path

      within("#merchant_names") do
        expect(page).to have_link("Schroeder-Jerde")
        click_link "Schroeder-Jerde"
        expect(page.current_path).to eq admin_merchant_path("1")
    end

      expect(page).to have_content("Schroeder-Jerde")
      expect(page).to_not have_content("Ernser, Borer and Marks")
      expect(page).to_not have_content("Jones and Stokes")

      visit admin_merchants_path

      within("#merchant_names") do
        expect(page).to have_link("Ernser, Borer and Marks")
        click_link "Ernser, Borer and Marks"
        expect(page.current_path).to eq admin_merchant_path("30")
      end

      expect(page).to have_content("Ernser, Borer and Marks")
      expect(page).to_not have_content("Schroeder-Jerde")
      expect(page).to_not have_content("Jones and Stokes")
    end

    it "Then I see a link to update the merchant's information. When I click the link, then I am taken to a page to edit this merchant" do
      visit admin_merchants_path

      expect(page).to have_link("New Merchant")
      click_link "New Merchant"

      expect(page.current_path).to eq admin_merchants_path
    end
  end
end
