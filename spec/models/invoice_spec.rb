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
      it 'returns the revenue after bulk discounts have been applied' do
        @m1 = Merchant.create!(name: 'Merchant 1')

        @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')

        @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")

        @item_1 = Item.create!(name: 'Shampoo', description: 'This washes your hair', unit_price: 10, merchant_id: @m1.id)
        @item_2 = Item.create!(name: 'Conditioner', description: 'This makes your hair shiny', unit_price: 8, merchant_id: @m1.id)
        @item_3 = Item.create!(name: 'Brush', description: 'This takes out tangles', unit_price: 5, merchant_id: @m1.id)  
        @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @m1.id)
        @item_5 = Item.create!(name: "Bracelet", description: "Wrist bling", unit_price: 200, merchant_id: @m1.id)

        @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 5, unit_price: 10, status: 0)
        @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 10, unit_price: 8, status: 0)
        @ii_3 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_3.id, quantity: 15, unit_price: 5, status: 2)
        @ii_4 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_4.id, quantity: 20, unit_price: 5, status: 1)
        @ii_5 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_5.id, quantity: 1, unit_price: 5, status: 1)
  
        @bulk_discount_1 = BulkDiscount.create!(name: "Christmas", discount: 30, quantity: 20, merchant_id: @m1.id)
        @bulk_discount_2 = BulkDiscount.create!(name: "Easter", discount: 20, quantity: 19, merchant_id: @m1.id)
        @bulk_discount_3 = BulkDiscount.create!(name: "MLK", discount: 15, quantity: 8, merchant_id: @m1.id)
        @bulk_discount_4 = BulkDiscount.create!(name: "Boxing Day", discount: 5, quantity: 5, merchant_id: @m1.id)

        expect(@invoice_1.total_discounted_revenue).to eq(254.25)
      end
    end
  end
end
