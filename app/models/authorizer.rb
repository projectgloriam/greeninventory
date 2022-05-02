class Authorizer < ActiveRecord::Base
	validates_presence_of :full_name
	validates_presence_of :username
	validates_presence_of :department
	validates_presence_of :level
end
