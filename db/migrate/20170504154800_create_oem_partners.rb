class CreateOemPartners < ActiveRecord::Migration
  def change
    create_table :oem_partners do |t|
      t.string :OEM_name
      t.attachment :OEM_logo

      t.timestamps null: false
    end
  end
end
