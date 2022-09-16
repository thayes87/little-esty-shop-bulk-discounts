require 'rails_helper'

RSpec.describe "merchant dashboard" do
  describe 'As a merchant, When I visit my merchant dashboard' do
    it 'I see the name of my merchant' do

      visit merchant_dashboards_path(Merchant.first)

      expect(page).to have_content(Merchant.first.name)
      expect(page).to_not have_content(Merchant.last.name)
    end

    it 'I see link to my merchant items index' do

      visit merchant_dashboards_path(Merchant.first)


      expect(page).to have_link("My Items")
    end

    it 'I see link to my merchant invoices index' do

      visit merchant_dashboards_path(Merchant.first)

      expect(page).to have_link("My Invoices")
    end

    #User story 3: Top 5 Customers
    xit 'I see the names of the top 5 customers who have conducted the largest number of successful transactions with my merchant' do
      visit merchant_dashboards_path(Merchant.first)

      xwithin ("#top_customers") do
        expected_hash = {}

        expect(Merchant.first.top_five_customers_by_merchant).to eq(expected_hash)
      end
    end

    xit 'Next to each customer name I see the number of successful transactions they have conducted with my merchant' do
      visit merchant_dashboards_path(Merchant.first)

      expected_hash = {}

      expect(page).to have_content(expected_hash)
    end

    describe 'I see a section for "Items Ready to Ship"' do
      xit 'In that section I see a list of the names of all of my items that have been ordered and have not yet been shipped' do
        visit merchant_dashboards_path(Merchant.first)

        within '#items_ready_to_ship' do
          expect(page).to have_content("Items Ready to Ship")
          expect(page).to have_content("#{Merchant.first.items.first.name}")
        end
      end

      xit 'Next to each item, I see the id of the invoice that ordered my item' do
        visit merchant_dashboards_path(Merchant.first)

        within "#item_#{Merchant.first.items.first.id}" do
          expect(page).to have_content(Merchant.first.items.first.id)
        end
      end

      xit 'Each invoice id is a link to my merchants invoice show page' do
        visit merchant_dashboards_path(Merchant.first)

        within "#item_#{Merchant.first.items.first.id}" do
          expect(page).to have_link("Invoice ##{Merchant.first.items.first.id}")
          click_on ()
          expect(current_path).to eq()
        end
      end
    end
  end
end

#   As a merchant
# When I visit my merchant dashboard
# Then I see a section for "Items Ready to Ship"
# In that section I see a list of the names of all of my items that
# have been ordered and have not yet been shipped,
# And next to each Item I see the id of the invoice that ordered my item
# And each invoice id is a link to my merchant's invoice show page
