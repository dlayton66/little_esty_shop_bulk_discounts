class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :merchants

  enum status: [:cancelled, 'in progress', :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def total_discounted_revenue
    return total_revenue if bulk_discounts.none?

    invoice_items.sum do |ii|
      ii.discounted_revenue
    end

    # invoice_items
    # .joins(:bulk_discounts)
    # .group(:item_id)
    # .minimum('
    #   CASE WHEN bulk_discounts.quantity <= invoice_items.quantity 
    #     THEN invoice_items.quantity*invoice_items.unit_price*(100-bulk_discounts.discount)/100
    #     ELSE invoice_items.quantity*invoice_items.unit_price
    #   END')
    # .values
    # .sum
  end
end
