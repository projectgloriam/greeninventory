class CreateSpecifications < ActiveRecord::Migration
  def change
    create_table :specifications do |t|
      t.string :case
      t.string :title
      t.string :client
      t.string :contact_person
      t.string :email
      t.string :telephone
      t.string :comment

      t.timestamps null: false
    end
  end
end
