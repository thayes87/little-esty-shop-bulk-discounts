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

    it "Then next to each merchant name I see a button to disable or enable that merchant." do
      visit admin_merchants_path

      within("#merchant_names") do
        expect(page).to have_button("enable")
        within("#1") do
          click_on "enable"
        end
        expect(page).to have_button("disable")
      end
    end

    it "When I click this button, Then I am redirected back to the admin merchants index, and I see that the merchant's status has changed" do
      visit admin_merchants_path

      within("#disabled_merchants") do
        expect(find_all("li").count).to eq 30

        within("#1") do
          expect(page).to have_button("enable")
          click_on "enable"
          expect(page.current_path).to eq admin_merchants_path
        end

        expect(find_all("li").count).to eq 29
      end

      within("#1") do
        expect(page).to have_button("disable")
        expect(page).to_not have_button("enable")
      end
    end

    it "Then I see two sections, one for 'Enabled Merchants' and one for 'Disabled Merchants'" do
      visit admin_merchants_path

      within("#merchant_names") do
        expect(page).to have_content("Disabled Merchants")
        expect(page).to have_content("Enabled Merchants")
      end
    end

    it "I see that each Merchant is listed in the appropriate section" do
      visit admin_merchants_path

      within("#1") do
        expect(page).to have_button("enable")
        click_on "enable"
        expect(page.current_path).to eq admin_merchants_path
      end

      within("#2") do
        expect(page).to have_button("enable")
        click_on "enable"
        expect(page.current_path).to eq admin_merchants_path
      end

      within("#3") do
        expect(page).to have_button("enable")
        click_on "enable"
        expect(page.current_path).to eq admin_merchants_path
      end

      within("#enabled_merchants") do
        expect(find_all("li").count).to eq 3
        expect(page).to have_content("Schroeder-Jerde")
        expect(page).to have_content("Klein, Rempel and Jones")
        expect(page).to have_content("Willms and Sons")
      end
    end

    it "I see a link to create a new merchant When I click on the link, I am taken to a form that allows me to add merchant information." do
      visit admin_merchants_path

      within("#admin_links") do
        expect(page).to have_link("New Merchant")
        click_on "New Merchant"
      end
      expect(page.current_path).to eq new_admin_merchant_path
      within("#new_merchant") do
        expect(page).to have_field("#merchant_name")
      end
    end

    it "When I fill out the form I click ‘Submit’, Then I am taken back to the admin merchants index page" do
      visit new_admin_merchant_path

      within("#new_merchant") do
        expect(page).to have_field("#merchant_name")
        fill_in "#merchant_name", with: "Dominic's Shop"
        click_on "Submit"
      end

      expect(page.current_path).to eq admin_merchants_path
    end

    it "I see the merchant I just created displayed and I see my merchant was created with a default status of disabled." do
      visit new_admin_merchant_path

      within("#new_merchant") do
        expect(page).to have_field("#merchant_name")
        fill_in "#merchant_name", with: "Dominic's Shop"
        click_on "Submit"
      end

      expect(page.current_path).to eq admin_merchants_path

      within("#disabled_merchants") do
        expect(page).to have_content("Dominic's Shop")
      end
    end
  end
end
