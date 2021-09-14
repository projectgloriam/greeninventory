class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include PublicActivity::StoreController

def current_user
	@current_user ||= User.find(session[:user_id]) if session[:user_id]
end

def cancel_session
  session[:specification_id] = nil if session[:specification_id]
  session[:specification] = nil if session[:specification]
  session[:equipment_id] = nil if session[:equipment_id]
  session[:equipment] = nil if session[:equipment]
end

  helper_method :current_user
  hide_action :current_user

private
	def confirmed_logged_in
	  unless session[:user_id]	
	    flash[:info] = "Please log in"
	    redirect_to(:controller => 'sessions', :action => 'new')
	    return false
	  else
	    return true
	  end
	end

	# This function is for authorising access to some pages and methods meant for a department.
	# Accepts the department that is required for access.
	def department(staff)
		# false means no access, true is access granted
		authorised = false
		if session[:group] then
			group = session[:group]
			#session[:group] is an array of names.
			# While looping, if one of the items in the array is equal to the staff that is required, then grant access
			group.each {|x| authorised = true if x == staff }
		end

		#if an item in the user's group string is equal to the required department, grant access 
		if authorised == true then
			return true 
		else
		#else send the user back to welcome, stating the reason why access was denied
		    flash[:alert] = "You are not authorised to access the page. It's meant for '#{staff}'"
		    redirect_to(:action => 'index')
		    return false
		end
	end

	#makes sure user can only read after testing is complete
    def readonly
		if session[:specification_id] then 
	  		spec = Specification.find(session[:specification_id])
	  	else
	   		spec = Specification.find(params[:id])
		end
		
		if spec.tested == true then
		redirect_to :controller => "equipment", :action => "index"
		flash[:warning] = "You can't edit or make changes to a tested Specification"
		return false
		else
		return true
		end
    end

	def autocomplete
	    @equipment_name = Equipment.select(:equipment_name).distinct

	    @models = Equipment.select(:model).distinct

	    @dates = Equipment.select(:created_at).distinct

	    @engineers = Equipment.select(:engineer).distinct

	    @job_sheet_numbers = Equipment.select(:job_sheet_number).distinct

	    @suppliers = Equipment.select(:supplier).distinct

	    @specification_cases = Specification.select(:case).distinct

	    @specification_clients = Specification.select(:client).distinct

	    @specification_titles = Specification.select(:title).distinct

	    @specification_contact_persons = Specification.select(:contact_person).distinct

	    @specification_emails = Specification.select(:email).distinct

	    @specification_authors = Specification.select(:author).distinct

	    @serials = Serial.select(:serial_number).distinct
	end

end
