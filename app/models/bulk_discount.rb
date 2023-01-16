class BulkDiscount < ApplicationRecord
  belongs_to :merchant

  scope :top_discount, -> { order(discount: :desc).first }
  scope :quantity_threshold, ->(threshold) { where('quantity <= ?', threshold) }
end