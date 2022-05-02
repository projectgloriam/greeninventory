class NotificationsController < ApplicationController
	before_action :confirmed_logged_in
	before_action :cancel_session #cancels session containing specification id
  	#before_action do
    	#department("support")
  	#end
  	before_action do
    	department("Domain Admins")
  	end

  def index
  	#how many items per a page
  	@perpage = 30
	@activities = PublicActivity::Activity.order('created_at DESC').paginate(:page => params[:page], :per_page => @perpage)

	#total number of activities
	@totalactivities = @activities.count

	#ruby's default numerical variable is integer. 
	#For example, if there are 92 activities and activities per page is 10, the number of pages will be 9.2. 
	#It should be rounded up to the next integer (which is 10)
	#The next line converts variables to float. And .ceil rounds their value up.
	@numberofpages = (@totalactivities.to_f / @perpage.to_f).ceil
  end
end