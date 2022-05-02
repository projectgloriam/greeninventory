class Equipment < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user ? controller.current_user : nil }

  validates_presence_of :equipment_name
  validates_presence_of :model
  validates_presence_of :job_sheet_number

  belongs_to :specification
  has_many :serials

  accepts_nested_attributes_for :serials, allow_destroy: true

end
