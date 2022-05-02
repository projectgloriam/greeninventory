class CreateAuthorizers < ActiveRecord::Migration
  def change
    create_table :authorizers do |t|
      t.string :full_name
      t.string :department
      t.integer :level

      t.timestamps null: false
    end
  end
end
