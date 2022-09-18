require 'rails_helper'

RSpec.describe 'As an admin,' do
  describe "When I visit a merchant's admin new page" do
    it "When I fill out the form I click ‘Submit’, Then I am taken back to the admin merchants index page" do
      visit new_admin_merchant_path

      within("#new_merchant") do
        expect(page).to have_field("merchant_name")
        fill_in "merchant_name", with: "Dominic's Shop"
        click_on "Create Merchant"
      end

      expect(page.current_path).to eq admin_merchants_path
    end

    it "I see the merchant I just created displayed and I see my merchant was created with a default status of disabled." do
      visit new_admin_merchant_path

      within("#new_merchant") do
        expect(page).to have_field("merchant_name")
        fill_in "merchant_name", with: "Dominic's Shop"
        click_on "Create Merchant"
      end

      expect(page.current_path).to eq admin_merchants_path

      within("#disabled_merchants") do
        expect(page).to have_content("Dominic's Shop")
      end
    end
  end
end