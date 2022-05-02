class Distributor < ActiveRecord::Base
	has_many :products
	validates_presence_of :distributor_name
	validates_presence_of :currency
	validates_presence_of :fairgreen_price_formula
end
