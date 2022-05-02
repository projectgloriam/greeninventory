class Client < ActiveRecord::Base
	has_many :purchase_orders
	validates_presence_of :name
	validates_presence_of :address
end
