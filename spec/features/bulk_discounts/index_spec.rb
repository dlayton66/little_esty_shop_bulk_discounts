require 'rails_helper'
require './app/api_helper'

RSpec.describe 'bulk discounts index' do
  before :each do
    @merchant_1 = Merchant.create!(name: 'Hair Care')
    @bulk_discounts = FactoryBot.create_list(:bulk_discount, 3, merchant: @merchant_1)
    
    @merchant_2 = Merchant.create!(name: 'Jewelry')
    @bulk_discount = FactoryBot.create(:bulk_discount, merchant: @merchant_2)
  
    visit merchant_bulk_discounts_path(@merchant_1)
  end
  
  it 'lists all discounts with links to show page' do
    expect(page).to have_link(@bulk_discounts[0].name, href: merchant_bulk_discount_path(@merchant_1, @bulk_discounts[0]))
    expect(page).to have_link(@bulk_discounts[1].name, href: merchant_bulk_discount_path(@merchant_1, @bulk_discounts[1]))
    expect(page).to have_link(@bulk_discounts[2].name, href: merchant_bulk_discount_path(@merchant_1, @bulk_discounts[2]))
  end
  
  it "doesn't have discounts from other merchants" do
    expect(page).to_not have_content(@bulk_discount.name)
  end

  it 'lists  discount info' do
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

  it 'lists 3 upcoming holidays' do
    upcoming_holidays = ApiHelper.new.next_three_holidays
    
    expect(page).to have_content(upcoming_holidays[0])
    expect(page).to have_content(upcoming_holidays[1])
    expect(page).to have_content(upcoming_holidays[2])
  end

  it 'has buttons to create discount for upcoming holidays' do
    upcoming_holidays = ApiHelper.new.next_three_holidays

    within("#upcoming_holidays-0") do
      expect(page).to have_button('Create Discount')
      click_button 'Create Discount'
    end

    expect(page).to have_current_path("/merchant/#{@merchant_1.id}/bulk_discounts/new?name=#{CGI.escape(upcoming_holidays[0])}")
    expect(page).to have_field(:bulk_discount_name, with: upcoming_holidays[0])
    expect(page).to have_field(:bulk_discount_discount, with: 30)
    expect(page).to have_field(:bulk_discount_quantity, with: 2)

    visit merchant_bulk_discounts_path(@merchant_1)

    within("#upcoming_holidays-1") do
      expect(page).to have_button('Create Discount')
      click_button 'Create Discount'
    end

    expect(page).to have_current_path("/merchant/#{@merchant_1.id}/bulk_discounts/new?name=#{CGI.escape(upcoming_holidays[1])}")
    expect(page).to have_field(:bulk_discount_name, with: upcoming_holidays[1])
    expect(page).to have_field(:bulk_discount_discount, with: 30)
    expect(page).to have_field(:bulk_discount_quantity, with: 2)

    visit merchant_bulk_discounts_path(@merchant_1)

    within("#upcoming_holidays-2") do
      expect(page).to have_button('Create Discount')
      click_button 'Create Discount'
    end

    expect(page).to have_current_path("/merchant/#{@merchant_1.id}/bulk_discounts/new?name=#{CGI.escape(upcoming_holidays[2])}")
    expect(page).to have_field(:bulk_discount_name, with: upcoming_holidays[2])
    expect(page).to have_field(:bulk_discount_discount, with: 30)
    expect(page).to have_field(:bulk_discount_quantity, with: 2)
  end

  describe 'discount deletion' do
    it 'has button which deletes each discount' do
      within("#bulk_discount-#{@bulk_discounts[0].id}") do
        expect(page).to have_button('Delete Bulk Discount')
        click_button('Delete Bulk Discount')
      end

      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant_1))
      expect(page).to_not have_content(@bulk_discounts[0].name)
      expect(page).to_not have_css("#bulk_discount-#{@bulk_discounts[0].id}")
    end
    
    it 'leaves other discounts unaffected' do
      within("#bulk_discount-#{@bulk_discounts[1].id}") do
        expect(page).to have_button('Delete Bulk Discount')
        click_button('Delete Bulk Discount')
      end
  
      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant_1))
      expect(page).to_not have_content(@bulk_discounts[1].name)
      expect(page).to_not have_css("#bulk_discount-#{@bulk_discounts[1].id}")

      expect(page).to have_content(@bulk_discounts[2].name)
      expect(page).to have_css("#bulk_discount-#{@bulk_discounts[2].id}")
    end
  end
end