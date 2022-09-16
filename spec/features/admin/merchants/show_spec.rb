RSpec.describe 'As an admin,' do
  describe "When I visit a merchant's admin show page" do
    it "Then I see a link to update the merchant's information. When I click the link, then I am taken to a page to edit this merchant" do
      visit admin_merchants_path

      expect(page).to have_link("Schroeder-Jerde")
      click_link "Schroeder-Jerde"
      expect(page.current_path).to eq admin_merchant_path(1)

      expect(page).to have_link("Update Merchant")
      click_link "Update Merchant"
      expect(page.current_path).to eq edit_admin_merchant_path(1)
    end
  end
end