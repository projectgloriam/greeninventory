class CreateLeaves < ActiveRecord::Migration
  def change
    create_table :leaves do |t|
      t.string :staff_name
      t.string :department
      t.string :commencement_date
      t.integer :days_applied_for
      t.string :vacation_address
      t.integer :authorizer
      t.integer :final_authorizer

      t.timestamps null: false
    end
  end
end
