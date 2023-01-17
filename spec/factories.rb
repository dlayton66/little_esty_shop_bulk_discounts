FactoryBot.define do
  factory :customer do
    first_name {Faker::Name.first_name}
    last_name {Faker::Dessert.variety}
  end

  factory :invoice do
    status {[0,1,2].sample}
    customer
  end

  factory :merchant do
    name {Faker::Space.galaxy}
  end

  factory :item do
    name {Faker::Coffee.variety}
    description {Faker::Hipster.sentence}
    unit_price {Faker::Number.decimal(l_digits: 2)}
    merchant
  end

  factory :transaction do
    result {[0,1].sample}
    credit_card_number {Faker::Finance.credit_card}
    invoice
  end

  factory :invoice_item do
    status {[0,1,2].sample}
    item
    invoice
    
    factory :invoice_item_single_purchase do
      item { create(:item, merchant: Merchant.first) }
      invoice { Invoice.first }
    end
  end

  factory :bulk_discount do
    discount {[*0..100].sample}
    quantity {[*5..30].sample}
    sequence(:name, 0) { |n| "Discount#{n}" }
    merchant

    factory :bulk_discount_single_merchant do
      merchant { Merchant.first }
    end
  end
end
