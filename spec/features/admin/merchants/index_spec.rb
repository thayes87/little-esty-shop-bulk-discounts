require 'rails_helper'

RSpec.describe 'As an admin,' do
  describe 'When I visit the admin Merchants index ("/admin/merchants")' do
    it 'Then I see the name of each merchant in the system' do
      visit admin_merchants_path

      within("#merchant_names") do
        merchant_ids = (1..30).to_a

        expect(page).to have_content("Schroeder-Jerde")
        expect(page).to have_content("Pollich and Koelpin")
        expect(page).to have_content("Jones and Stokes")
        expect(page).to have_content("Ernser, Borer and Marks")

        merchant_ids.each {|id| expect(page.has_css?("##{id}")).to eq true}
      end
    end

    it "When I click on the name of a merchant from the admin merchants index page, I am taken to that merchant's admin show page (/admin/merchants/merchant_id)" do

    end
  end
end
