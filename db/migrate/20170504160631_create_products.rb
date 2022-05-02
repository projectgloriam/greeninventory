class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :product_part_number
      t.string :product_description
      t.integer :product_quantity
      t.string :product_price
      t.references :product_category, index: true, foreign_key: true
      t.references :oem_partner, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
