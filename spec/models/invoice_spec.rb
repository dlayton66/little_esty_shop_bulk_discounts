require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end

  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many :transactions }
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many(:bulk_discounts).through(:merchants) }
  end

  describe "instance methods" do
    it "total_revenue" do
      @merchant_1 = Merchant.create!(name: 'Hair Care')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant_1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant_1.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)

      expect(@invoice_1.total_revenue).to eq(100)
    end

    describe '#total_discounted_revenue' do
      before :each do
        FactoryBot.create(:merchant)
        @invoice_1 = FactoryBot.create(:invoice)

        FactoryBot.create(:invoice_item_single_purchase, quantity: 5, unit_price: 10)
        FactoryBot.create(:invoice_item_single_purchase, quantity: 10, unit_price: 8)
        FactoryBot.create(:invoice_item_single_purchase, quantity: 15, unit_price: 5)
        FactoryBot.create(:invoice_item_single_purchase, quantity: 20, unit_price: 5)
        FactoryBot.create(:invoice_item_single_purchase, quantity: 1, unit_price: 5)

        FactoryBot.create(:bulk_discount_single_merchant, name: "Christmas", discount: 30, quantity: 20)
        FactoryBot.create(:bulk_discount_single_merchant, name: "Easter", discount: 20, quantity: 19)
        FactoryBot.create(:bulk_discount_single_merchant, name: "MLK", discount: 15, quantity: 8)
        FactoryBot.create(:bulk_discount_single_merchant, name: "Boxing Day", discount: 5, quantity: 5)
      end

      it 'returns the revenue after bulk discounts have been applied' do
        expect(@invoice_1.total_discounted_revenue).to eq(254.25)
      end

      it 'adjusts the total discounted revenue when new discounts are added' do
        FactoryBot.create(:bulk_discount_single_merchant, name: "Presidents Day", discount: 20, quantity: 10)

        expect(@invoice_1.total_discounted_revenue).to eq(246.5)
      end

      it 'adjusts the total discounted revenue when new invoice items are added' do
        FactoryBot.create(:invoice_item_single_purchase, quantity: 20, unit_price: 20)

        expect(@invoice_1.total_discounted_revenue).to eq(534.25)
      end

      it 'returns the total revenue if no discounts exist' do
        BulkDiscount.destroy_all

        expect(@invoice_1.total_discounted_revenue).to eq(@invoice_1.total_revenue)
      end
    end
  end
end
