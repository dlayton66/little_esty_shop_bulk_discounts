require 'rails_helper'

RSpec.describe 'bulk discount show' do
  before :each do
    @merchant_1 = Merchant.create!(name: 'Hair Care')
    @bulk_discount_1 = BulkDiscount.create!(name: 'Christmas', discount: 30, quantity: 5, merchant_id: @merchant_1.id)

    @merchant_2 = Merchant.create!(name: 'Jewelry')
    @bulk_discount_2 = BulkDiscount.create!(name: 'Easter', discount: 30, quantity: 5, merchant_id: @merchant_2.id)

    visit merchant_bulk_discount_path(@merchant_1, @bulk_discount_1)
  end

  it 'shows the discount attributes' do
    expect(page).to have_content(@bulk_discount_1.name)
    expect(page).to have_content(@bulk_discount_1.discount)
    expect(page).to have_content(@bulk_discount_1.quantity)
  end

  it "doesn't show other discount attributes" do
    expect(page).to_not have_content(@bulk_discount_2.name)
  end

  it 'has a link to edit' do
    expect(page).to have_link('Edit', href: edit_merchant_bulk_discount_path(@merchant_1, @bulk_discount_1))
  end
end