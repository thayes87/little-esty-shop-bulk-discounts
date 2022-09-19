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
    end
  end
end