require 'rails_helper'

RSpec.describe 'Merchant Invoices Index Page' do
  describe 'As a merchant' do
    describe 'When I visit my merchant invoices index page' do
      it 'shows me all of the invoices that include at least one of my merchant items' do
        visit merchant_invoices_path(Merchant.first)



      end
    end
  end
end
