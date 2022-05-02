class CreateDistributors < ActiveRecord::Migration
  def change
    create_table :distributors do |t|
      t.string :name
      t.string :currency
      t.string :fairgreen_price_formula

      t.timestamps null: false
    end
  end
end
