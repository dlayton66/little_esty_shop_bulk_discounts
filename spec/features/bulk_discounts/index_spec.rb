require 'rails_helper'

RSpec.describe 'bulk discounts index' do
  before :each do
    @merchant_1 = Merchant.create!(name: 'Hair Care')
    @merchant_2 = Merchant.create!(name: 'Jewelry')
  
    @bulk_discounts = FactoryBot.create_list(:bulk_discount, 3, merchant: @merchant_1)
    @bulk_discount = FactoryBot.create(:bulk_discount, merchant: @merchant_2)
  
    visit merchant_bulk_discounts_path(@merchant_1)
  end
  
  it 'lists all discounts with links to show page' do
    expect(page).to have_link(@bulk_discounts[0].name, href: merchant_bulk_discount_path(@merchant_1, @bulk_discounts[0]))
    expect(page).to have_link(@bulk_discounts[1].name, href: merchant_bulk_discount_path(@merchant_1, @bulk_discounts[1]))
    expect(page).to have_link(@bulk_discounts[2].name, href: merchant_bulk_discount_path(@merchant_1, @bulk_discounts[2]))
  
    expect(page).to_not have_content(@bulk_discount.name)
  end

  it 'lists discount info' do
    within("#bulk_discount-#{@bulk_discounts[0].id}") do
      expect(page).to have_content(@bulk_discounts[0].discount)
      expect(page).to have_content(@bulk_discounts[0].quantity)
    end

    within("#bulk_discount-#{@bulk_discounts[1].id}") do
      expect(page).to have_content(@bulk_discounts[1].discount)
      expect(page).to have_content(@bulk_discounts[1].quantity)
    end
    
    within("#bulk_discount-#{@bulk_discounts[2].id}") do
      expect(page).to have_content(@bulk_discounts[2].discount)
      expect(page).to have_content(@bulk_discounts[2].quantity)
    end
  end

  it 'has a link to create a new discount' do
    expect(page).to have_link('Create Bulk Discount', href: new_merchant_bulk_discount_path(@merchant_1))
  end

  it 'has button which deletes each discount' do
    within("#bulk_discount-#{@bulk_discounts[0].id}") do
      expect(page).to have_button('Delete Bulk Discount')
      click_button('Delete Bulk Discount')
    end

    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant_1))
    expect(page).to_not have_content(@bulk_discounts[0].name)
    expect(page).to_not have_content(@bulk_discounts[0].discount)
    expect(page).to_not have_content(@bulk_discounts[0].quantity)

    within("#bulk_discount-#{@bulk_discounts[1].id}") do
      expect(page).to have_button('Delete Bulk Discount')
      click_button('Delete Bulk Discount')
    end

    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant_1))
    expect(page).to_not have_content(@bulk_discounts[1].name)
    expect(page).to_not have_content(@bulk_discounts[1].discount)
    expect(page).to_not have_content(@bulk_discounts[1].quantity)

    it 'leaves other discount info unaffected' do
      expect(page).to have_content(@bulk_discounts[2].name)
      expect(page).to have_content(@bulk_discounts[2].discount)
      expect(page).to have_content(@bulk_discounts[2].quantity)
    end
  end
end