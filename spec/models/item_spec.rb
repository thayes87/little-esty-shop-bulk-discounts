require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:invoices).through (:invoice_items) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:merchant_id) }
  end

  describe 'class methods' do
    describe '.ready_to_ship' do
      it 'can list all of a merchants items that are ready to ship' do
        expect(Item.ready_to_ship(1)).to eq([])
      end
    end
  end
end
