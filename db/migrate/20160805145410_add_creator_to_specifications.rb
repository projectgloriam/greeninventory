class AddCreatorToSpecifications < ActiveRecord::Migration
  def up
  	add_column "specifications", "author", :string
  end

  def down
  	remove_column "specifications", "author"
  end
end
