require 'rails_helper'

RSpec.describe 'Merchant Invoices Show Page' do
  describe 'As a merchant' do
    describe 'When I visit my merchant invoices show page' do
      it 'Then I see information related to that invoice' do
        @merchant = Merchant.first
        invoice_1 = @merchant.invoices.first
        invoice_2 = @merchant.invoices.last
        
        visit merchant_invoice_path(@merchant, invoice_1)

          expect(page).to have_content("Invoice ID: 1")
          expect(page).to have_content("Invoice Status: cancelled")
          expect(page).to have_content("Invoice Date: Sunday, March 25, 2012")
          expect(page).to have_content("Invoice Customer Name: Joey Ondricka")
          expect(page).to_not have_content("Invoice ID: 5")
      end

      it 'I see all of my items on the invoice including the name' do
        @merchant = Merchant.first
        invoice_1 = @merchant.invoices.first

        visit merchant_invoice_path(@merchant, invoice_1)
        
        within "div#1" do
          expect(page).to have_content("Item Name: Item Qui Esse")
          expect(page).to have_content("Item Quantity: 5")
          expect(page).to have_content("Item Unit Price: $136.35")
          expect(page).to have_content("Item Status: packaged")

          expect(page).to_not have_content("Item Name: Item Expedita Aliquam")
          expect(page).to_not have_content("Item Name: Provident At")
        end
      end
    end
  end
end