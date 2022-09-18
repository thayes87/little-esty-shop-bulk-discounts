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
    describe '.enabled_items' do
      it 'returns a list of all the items that are enabled for a specific merchant' do
        merchant = Merchant.first
        expect(merchant.enabled_items.count).to eq(0)

        merchant.items.first.update(status: "enabled")
        expect(merchant.enabled_items.count).to eq(1)
      end
    end

    describe '.disabled_items' do
      it 'returns a list of all the items that are disabled for a specific merchant' do
        merchant = Merchant.first
        expect(merchant.disabled_items.count).to eq(3)

        merchant.items.first.update(status: "enabled")
        expect(merchant.disabled_items.count).to eq(2)
      end
    end
  end
end
