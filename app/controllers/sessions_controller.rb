class SessionsController < ApplicationController

	def new
		if current_user then
			redirect_to root_path
		else
			flash[:info] = "Please login" if flash[:info].blank?
		end
	end

	def create
		ldap_user = Adauth.authenticate(params[:username], params[:password])
		if ldap_user then
        	user = User.return_and_create_from_adauth(ldap_user)
        	session[:user_id] = user.id
        	session[:user_name] = user.name
        	session[:login] = user.login
        	grouping = user.group_strings.tr('[]"','') #user.group_strings is the department e.g. logistics. tr() removes [] and " because it's a string
        	grouping = grouping.split(', ') #split converts it into an array. incase the user belongs to many groups, it removes comma and space
        	session[:group] = grouping
        	flash[:success] = "Welcome #{session[:user_name]}"
        	
        	unless session[:requested_page]
        		redirect_to(:controller => :welcome, :action => :index)
        	else
        		redirect_to "#{session[:requested_page]}"
        	end
        	# redirect_to root_path
    	else
        	# redirect_to root_path, :error => "Invalid Login"
        	flash[:alert] = "Invalid Login"
        	redirect_to(:action => "new")
    	end
	end

	def destroy
		#cancel every session before logout incase they don't end
		session[:user_id] = nil
		session[:user_name] = nil
		session[:login] = nil
		session[:group] = nil
		cancel_session
		flash[:info] = "You are now logged out"
		redirect_to(:action => "new")
	end
end