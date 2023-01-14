class CreateBulkDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :bulk_discounts do |t|
      t.integer :discount
      t.integer :quantity

      t.timestamps
    end
  end
end
