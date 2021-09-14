class CreateSerials < ActiveRecord::Migration
  def change
    create_table :serials do |t|
      t.string :serial_number
      t.references :equipment, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
