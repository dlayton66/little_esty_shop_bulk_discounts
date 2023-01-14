require 'rails_helper'

RSpec.describe 'bulk discounts index' do
  it 'lists all discounts' do
    merchant_1 = Merchant.create!(name: 'Hair Care')
    merchant2 = Merchant.create!(name: 'Jewelry')

    bulk_discounts = FactoryBot.create_list(:bulk_discount, 3, merchant: merchant_1)
    bulk_discount = FactoryBot.create(:bulk_discount, merchant: merchant2)

    visit merchant_bulk_discounts_path(merchant_1)

    expect(page).to have_content(bulk_discounts[0].name)
    expect(page).to have_content(bulk_discounts[1].name)
    expect(page).to have_content(bulk_discounts[2].name)

    expect(page).to_not have_content(bulk_discount.name)
  end
end