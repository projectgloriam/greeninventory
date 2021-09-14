class WelcomeController < ApplicationController
	before_action :confirmed_logged_in
	before_action :cancel_session #cancels session containing specification id
  
	def index
		@specs = Specification.all
		@notifications = 0
		@specs.each do |spec|
			@notifications += 1 if spec.tested == false
		end
		cancel_session
	end
end
