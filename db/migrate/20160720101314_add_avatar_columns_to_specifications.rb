class AddAvatarColumnsToSpecifications < ActiveRecord::Migration
  def up
    add_attachment :specifications, :avatar
  end

  def down
    remove_attachment :specifications, :avatar
  end
end
