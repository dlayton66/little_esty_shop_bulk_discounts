require 'rails_helper'

RSpec.describe 'bulk discount show' do
  before :each do
    @merchant = Merchant.create!(name: 'Hair Care')
    @bulk_discount = BulkDiscount.create!(name: 'Christmas', discount: 30, quantity: 5, merchant_id: @merchant.id)

    visit merchant_bulk_discount_path(@merchant, @bulk_discount)
  end

  it 'shows the discount attributes' do
    expect(page).to have_content(@bulk_discount.name)
    expect(page).to have_content(@bulk_discount.discount)
    expect(page).to have_content(@bulk_discount.quantity)
  end
end