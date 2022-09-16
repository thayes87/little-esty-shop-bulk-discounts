require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many(:items) }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'instance methods' do
    describe '#items_ready_to_ship' do
      it 'can list all of a merchants items that are ready to ship' do
        expect(Merchant.first.items_ready_to_ship).to eq([Item.find(1), Item.find(3)])
      end
    end
  end
end
