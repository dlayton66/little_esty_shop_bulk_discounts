require 'rails_helper'

RSpec.describe 'bulk discount edit page' do
  before :each do
    @merchant = Merchant.create!(name: 'Hair Care')
    @bulk_discount = BulkDiscount.create!(name: 'Christmas', discount: 30, quantity: 5, merchant_id: @merchant.id)

    visit edit_merchant_bulk_discount_path(@merchant, @bulk_discount)
  end

  it 'has a prefilled form to edit the discount' do
    expect(page).to have_field(:bulk_discount_name, with: 'Christmas')
    expect(page).to have_field(:bulk_discount_discount, with: 30)
    expect(page).to have_field(:bulk_discount_quantity, with: 5)
  end

  it 'can fully the discount' do
    fill_in :bulk_discount_name, with: 'Easter'
    fill_in :bulk_discount_discount, with: 31
    fill_in :bulk_discount_quantity, with: 6
    click_button 'Update'

    expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @bulk_discount))
    expect(page).to have_content('Easter')
    expect(page).to have_content(31)
    expect(page).to have_content(6)

    expect(page).to_not have_content('Christmas')
    expect(page).to_not have_content(30)
    expect(page).to_not have_content(5)
  end

  it 'can partially edit the discount' do
    fill_in :bulk_discount_name, with: 'Easter'
    fill_in :bulk_discount_discount, with: 31
    click_button 'Update'

    expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @bulk_discount))
    expect(page).to have_content('Easter')
    expect(page).to have_content(31)
    expect(page).to have_content(5)

    expect(page).to_not have_content('Christmas')
    expect(page).to_not have_content(30)
  end
end