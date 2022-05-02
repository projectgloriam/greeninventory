class CreatePurchaseOrders < ActiveRecord::Migration
  def change
    create_table :purchase_orders do |t|
      t.string :purchase_order_title
      t.references :client, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
