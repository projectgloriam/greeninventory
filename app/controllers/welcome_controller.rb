class WelcomeController < ApplicationController
	before_action :confirmed_logged_in, except: [:thumbnail]
	before_action :cancel_session, :except => :thumbnail #cancels session containing specification id
	layout false, :except => :index
  
	def index
		@specs = Specification.all
		@notifications = 0
		@specs.each do |spec|
			@notifications += 1 if spec.tested == false
		end

		@users=ldap_search

		cancel_session
		#fetch list of authorizers id
		authorizers = Array.new

		#find the authorizers whose level is level 3
		Authorizer.where("level = ?",3).find_each do |authorizer|
		  authorizers << authorizer.full_name
		end

		#current_user
		current_user = session[:user_name]

		#everyone is entitled to 20 working leave days
		@leave_days_entitled_to = 20

		#current_year
		current_year = Time.now.year

		#beginning of the year
		beginning_of_the_year = Time.new(current_year, 1, 1)

		#end of the year
		end_of_the_year = Time.new(current_year, 12, 31)

		#calculate the sum of every leave the user has had that is between the beginning and the end of this year
		@leave_days_spent = Leave.sum(:days_applied_for, :conditions => ["created_at > ? AND created_at <= ? AND staff_name=? AND final_authorizer IN (?)", beginning_of_the_year,end_of_the_year,current_user,authorizers])

		p "Leave days spent is " + @leave_days_spent.to_s

		#leave days due for the person to use
		@leave_days_due = @leave_days_entitled_to - @leave_days_spent

		p "Leave days left is " + @leave_days_due.to_s

		today_date = Date.today

		#fetch leaves that has been authorized by both level 2 and 3 authorizers
		@leaves = Leave.where("resumption_date < ? AND authorizer <> ? AND final_authorizer <> ?",today_date,"","")
	end

	def thumbnail
		if params[:query] then
			if params[:query] != "" then
				object = LinkThumbnailer.generate('http://www.google.com.gh/search?tbm=isch&q='+params[:query])
				@image = object.images.first.src.to_s
				@title = params[:query]
			else
				@image = '/assets/image_not_available.gif'
				@title = 'Image Not Available'
			end
		else
			@image = '/assets/image_not_available.gif'
			@title = 'Image Not Available'
		end
	end

	#POST /process_events
	def process_events
		#get file directory
		filedir = "C:/Sites/GreenInventory/public/events.json"

		#get the key for params because they are the same as the keys in the JSON file
		key = params.keys[0]

		if params[key] then
			p "params " + key + " is present."
			#convert json string into ruby data (array to array / object to hash)
			data = JSON params[key]

			#if the key is "rounds", add the department of the user sending the rounds 
			if key == "rounds" then 
				data["department"] = session[:group].join(",")
				p "department was " + data["department"].to_s
			end

			#read JSON file
			file = IO.read(filedir)

			p "fetching the json file: " + file

			#convert JSON file to ruby data
			file = JSON file

			case params['CRUD']
			when 'create'
				p 'This is a ' + params['CRUD'].to_s + " action"
			  	#if its a round, insert data into the "rounds" key in the hash
				file[key] << data
			when 'update', 'delete'
				p 'This is a ' + params['CRUD'].to_s + " action"
				p "checking each element for key: " + key + " in file"
			  	file[key].each_with_index do |object, index|
			  		p object['title'].to_s
			  		p data['title'].to_s
			  		case params[key]
			  		when 'public_holidays'
			  			if (object['title'] == data['title'] ) then
			  				object['start'] = data['start']
			  			end
			  		else
				  		if (object['title'] == data['title'] && object['location'] == data['location'] && object['task'] == data['task'] && object['staff'] == data['staff']) then
				  			p "found the matching object"
				  			case params['CRUD']
							when 'update'
								object['start'] = data['start']
				  				object['end'] = data['end']
							when 'delete'
								file[key].delete_at(index)
							end
				  		end
			  		end

			  	end

			end

			#convert ruby data back to JSON
			file = JSON file

			#write data back to file (overwrite)
			IO.write(filedir, file)
		end
	end

	def login
	end
end
