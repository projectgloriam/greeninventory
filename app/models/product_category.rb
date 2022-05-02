class ProductCategory < ActiveRecord::Base
	has_many :products
	validates_presence_of :category_name
end
