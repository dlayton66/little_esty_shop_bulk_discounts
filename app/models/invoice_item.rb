class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id,
                        :item_id,
                        :quantity,
                        :unit_price,
                        :status

  belongs_to :invoice
  belongs_to :item
  has_many :bulk_discounts, through: :item

  enum status: [:pending, :packaged, :shipped]

  def self.incomplete_invoices
    invoice_ids = InvoiceItem.where("status = 0 OR status = 1").pluck(:invoice_id)
    Invoice.order(created_at: :asc).find(invoice_ids)
  end

  def discounted_revenue
    if top_discount == []
      quantity * unit_price
    else
      quantity * unit_price * (100 - top_discount.discount) / 100
    end
  end

  def top_discount
    # require 'pry', binding.pry
    bulk_discounts.quantity_threshold(quantity).top_discount
  end
end
