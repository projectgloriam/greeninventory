class Serial < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user ? controller.current_user : nil }
  
  validates_presence_of :serial_number

  belongs_to :equipment
end
