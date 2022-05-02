class Leave < ActiveRecord::Base
	validates_presence_of :staff_name
	validates_presence_of :username
	validates_presence_of :department
	validates_presence_of :commencement_date
	validates_presence_of :resumption_date
	validates_presence_of :days_applied_for
end
