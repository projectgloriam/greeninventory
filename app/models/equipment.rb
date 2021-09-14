class Equipment < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user ? controller.current_user : nil }

  validates_presence_of :equipment_name
  validates_presence_of :model
  validates_presence_of :job_sheet_number
  validates_presence_of :supplier
  validates_presence_of :customer_Warranty_start
  validates_presence_of :customer_Warranty_end

  belongs_to :specification
  has_many :serials

end
