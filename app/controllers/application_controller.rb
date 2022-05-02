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
  session[:purchase_order_id] = nil if session[:purchase_order_id]
  session[:purchase_order] = nil if session[:purchase_order]
end

  helper_method :current_user, :confirmed_logged_in, :readDoc
  #hide_action :current_user

private
	def ldap_search
		users = Array.new
		ldap = Net::LDAP.new  :host => "green.local", # your LDAP host name or IP goes here,
		                      :port => "389", # your LDAP host port goes here,
		                      :base => "DC=green,DC=local", # the base of your AD tree goes here,
		                      :auth => {
		                        :method => :simple,
		                        :username => "promo", # a user w/sufficient privileges to read from AD goes here,
		                        :password => "Passw0rd1" # the user's password goes here
		                      }

        # GET THE DISPLAY NAME AND E-MAIL ADDRESS FOR A SINGLE USER
		result_attrs = [:name]

		# Build filter
		search_filter = "(&(objectCategory=person)(objectClass=user))"

		# Execute search
        ldap.search(:filter => search_filter, :attributes => result_attrs){|item| 
			users << item.name.first
        }

        return users
	end

	def access_level(username)
		#by default the user is not authorized
		level = 0

		level = 1 if username == session[:user_name]

		#loop through each authorizer
		Authorizer.find_each do |auth|
		  #if authorizer is found, ...
		  if auth.full_name == username then
		  	case auth.level
		  	#if the authorizer's level is two, and the authorizer is not not on the same department as the current user, 
		  	#let the level remain at zero (meaning, he has no authority to access) otherwise show the authorizer's level
		  	when 2
	  			level = auth.level
		  	when 3
		  		#if the authorizer's level is three, it means it's either the CEO or the CTO
		  		level = auth.level
		  	end
		  end
		end
		return level
	end

	def confirmed_logged_in
	  unless session[:user_id]	
	  	#store the requested url in a session for later use
	  	session[:requested_page] = request.fullpath

	    flash[:info] = "Please log in."
	    redirect_to(:controller => 'sessions', :action => 'new')
	    return false
	  else
	  	#cancel requested page session
	  	session[:requested_page] = nil if session[:requested_page]
		#under_construction("Fritz Adomako")
	    return true
	  end
	end

	# if you want to restrict the site under development to the developer
	def under_construction(staff_username)
	  if session[:user_name]==staff_username
	    return true
	  else
	    flash[:info] = "Site is under development & will be back shortly"
	    redirect_to '/under_construction.html'
	    return false
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

		    flash[:alert] = "You are not authorised to access the page. It's meant for '#{staff}'"
		    redirect_to(:action => 'index')

		    return false
		end
	end

	#makes sure user can only read after testing is complete
    def readonly
	   	case
		when session.has_key?('specification_id')
		  @spec = Specification.find(session[:specification_id])
		  p 'session specification id is ' + session[:specification_id].to_s
		  p 'tested status is ' + @spec.tested.to_s
		when controller_name=='specifications'
		  @spec = Specification.find(params[:id])
		else
			if controller_name != ('equipment' || 'serials') then
				redirect_to :controller => "specifications", :action => "index"	
			else
				render :nothing => true, :status => 200, :content_type => 'text/html'
			end

			flash[:warning] = "Cant find Specification ID. Please select a specification case."

			return false
		end

		#when accessing a boolean attribute, add question mark at the end
		@spec_tested = @spec.tested?
		
		if @spec_tested == true then
			redirect_to :controller => "equipment", :action => "index"
			flash[:warning] = "You can't edit or make changes to a tested Specification"
			return false
		else
			return true
		end
    end

    # https://grosser.it/2008/11/24/rails-transform-path-to-url
	def path_to_url(path)
    	"#{request.protocol}#{request.host_with_port.sub(/:80$/,'')}/#{path.sub 'C:/Sites/GreenInventory/public/', ''}"
  	end

    #read office documents
    def readDoc(docPath)
    	#read word documents
    	require 'docx'
    	
    	#read excel files
       	require 'roo'

       	#read outlook files
    	require 'mapi/msg'

    	#This is an object of the mime types the document contains
    	doc_mime_types = MIME::Types.type_for(docPath)

    	mime_types = Array.new

    	#fetch each value of the object into an array
    	doc_mime_types.each { |mime| 
    		mime_types << mime.to_s
    	}

    	#mime types for word documents
    	doc_mime_types = ["application/msword", "application/vnd.openxmlformats-officedocument.wordprocessingml.document"]

    	#mime types for excel documents
    	excel_mime_types = ["application/vnd.ms-excel", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"]

    	#mime types for outlook documents
    	outlook_mime_types = ["application/vnd.ms-outlook"]

    	#mime types for pdf documents
    	pdf_mime_types = ["application/pdf"]

    	results = ""

    	mime_type_found = true

    	case
    	#when some mime types are common in both arrays, use the gem to read the document and return data
		when (mime_types & doc_mime_types).length > 0
			# Retrieve and display paragraphs as html
			doc = Docx::Document.open(docPath)
			#doc.paragraphs.each do |p|
			  puts doc.to_html.to_s
			  results = results + doc.to_html.to_s
			  #results = results + p.to_s + "\n"
			#end

		#parse excel if the mime type is excel
		when (mime_types & excel_mime_types).length > 0
			xlsx = Roo::Spreadsheet.open(docPath)

			# Iterate through each sheet
			xlsx.each_with_pagename do |sheetName, sheet|
			  #display the sheet's name on top of table
			  results = results + "<h2>" + sheetName + "</h2>"
			  
			  #start table for each sheet
				results = results + "<table>"

				#Iterate through each row
				(1..xlsx.sheet(sheetName).last_row).each do |i|
				  results = results + "<tr>"

				  #each row
			      row = xlsx.sheet(sheetName).row(i)

			      #Iterate through each cell data for this row
			      row.each { |cell| 
			      	results = results + "<td>" + cell.to_s + "</td>"
			      }

				  results = results + "</tr>" 
			    end

			    results = results + "</table>"

			end

		#parse outlook file if the mime type is excel
		when (mime_types & outlook_mime_types).length > 0
		  	msg = Mapi::Msg.open docPath
		  	results = msg.body_to_mime.to_s

		#parse pdf files if the mime type is pdf
		when (mime_types & pdf_mime_types).length > 0
		  results = '<script>$(function() {	var options = {width: "40rem", height: "40rem"};'
		  results = results + 'PDFObject.embed("' + path_to_url(docPath) + '", "#viewer", options); });'
		  results = results + 'function fullScreen(){ PDFObject.embed("' + path_to_url(docPath) + '");}</script>'
		  results = results + '<div id="viewer"></div><a href="#" onclick="fullScreen();" class="button rounded">Fullscreen</a>'

		#else display an error that file cant be read
		else
			mime_type_found = false
		end

		if mime_type_found == false then
			results = "Sorry, cant read the file because file type is not supported."
		else
			results = "<div id='attachment' style='width: 100%; overflow-y:scroll;height: 100%;'>" + results + "</div>
						<script>
							$(function() { 
								$('#attachment').find('*').css({'font-size': '100%', 'line-height': '100%'}); 
								$('#attachment').height($(window).height());
							});
						</script>"
			results = results.html_safe
		end

		#return mime_types
		return results
    end

	def autocomplete
	    @equipment_name = Equipment.select(:equipment_name).distinct

	    @models = Equipment.select(:model).distinct

	    @dates = Equipment.select(:created_at).distinct

	    @engineers = Equipment.select(:engineer).distinct

	    @job_sheet_numbers = Equipment.select(:job_sheet_number).distinct

	    @specification_cases = Specification.select(:case).distinct

	    @specification_clients = Specification.select(:client).distinct

	    @specification_titles = Specification.select(:title).distinct

	    @specification_contact_persons = Specification.select(:contact_person).distinct

	    @specification_emails = Specification.select(:email).distinct

	    @specification_authors = Specification.select(:author).distinct

	    @suppliers = Specification.select(:supplier).distinct

	    @serials = Serial.select(:serial_number).distinct
	end

end
