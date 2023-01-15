require 'rails_helper'

RSpec.describe 'new bulk discount', type: :feature do
  before :each do
    @merchant_1 = Merchant.create!(name: 'Hair Care')
    visit new_merchant_bulk_discount_path(@merchant_1)
  end

  it 'has a form to add new bulk discount' do
    expect(page).to have_field(:bulk_discount_name)
    expect(page).to have_field(:bulk_discount_discount)
    expect(page).to have_field(:bulk_discount_quantity)
    expect(page).to have_button('Create Bulk Discount')
  end

  it 'adds new bulk discount for merchant' do
    fill_in(:bulk_discount_name, with: "Boxing Day")
    fill_in(:bulk_discount_discount, with: 17)
    fill_in(:bulk_discount_quantity, with: 18)
    click_button 'Create Bulk Discount'

    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant_1))
    expect(page).to have_content("Boxing Day")
    expect(page).to have_content(17)
    expect(page).to have_content(18)
  end
end