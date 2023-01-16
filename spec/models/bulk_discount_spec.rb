require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  before :each do
    @merchant_1 = Merchant.create!(name: 'Hair Care')

    @bulk_discount_1 = BulkDiscount.create!(name: "Christmas", discount: 30, quantity: 5, merchant_id: @merchant_1.id)
    @bulk_discount_2 = BulkDiscount.create!(name: "Easter", discount: 20, quantity: 10, merchant_id: @merchant_1.id)
    @bulk_discount_3 = BulkDiscount.create!(name: "MLK", discount: 5, quantity: 20, merchant_id: @merchant_1.id)
    @bulk_discount_4 = BulkDiscount.create!(name: "Boxing Day", discount: 35, quantity: 5, merchant_id: @merchant_1.id)
    @bulk_discount_5 = BulkDiscount.create!(name: "Juneteenth", discount: 36, quantity: 11, merchant_id: @merchant_1.id)
  end

  describe 'relationships' do
    it { should belong_to :merchant }
  end

  describe 'scopes' do
    describe '.top_discount' do
      it 'returns the BulkDiscount object with the highest discount' do
        expect(BulkDiscount.top_discount).to eq(@bulk_discount_5)
        expect(BulkDiscount.quantity_threshold(10).top_discount).to eq(@bulk_discount_4)
      end
    end

    describe '.quantity_threshold' do
      it 'returns the BulkDiscounts which meet the purchase quantity threshold' do
        expect(BulkDiscount.quantity_threshold(10)).to eq([@bulk_discount_1, @bulk_discount_2, @bulk_discount_4])
      end
    end
  end
end