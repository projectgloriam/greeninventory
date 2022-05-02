class AddResumptionDateToLeaves < ActiveRecord::Migration
  def up
  	add_column "leaves", "resumption_date", :string
  end

  def down
  	remove_column "leaves", "resumption_date"
  end
end
