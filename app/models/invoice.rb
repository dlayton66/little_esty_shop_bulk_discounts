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
    invoice_items.sum do |ii|
      ii.discounted_revenue
    end
    # invoice_items
    # .joins(:bulk_discounts)
    # .where("bulk_discounts.quantity <= invoice_items.quantity")
    # .group(:item_id)
    # .minimum('invoice_items.quantity*invoice_items.unit_price*(100-bulk_discounts.discount)/100')
    # .values
    # .sum
  end
end
