class Product < ActiveRecord::Base

  #validates_presence_of :product_part_number
  validates_presence_of :product_description
  validates_presence_of :product_price
  validates_presence_of :distributor_id
  #validates_presence_of :product_category_id
  #validates_presence_of :oem_partner_id

  belongs_to :product_category
  belongs_to :oem_partner
  belongs_to :distributor
end
