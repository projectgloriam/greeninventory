class User < ActiveRecord::Base
	# has_secure_password
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user ? controller.current_user : nil }

	include Adauth::Rails::ModelBridge

    AdauthMappings = {
        :login => :login,
        :group_strings => :cn_groups, 
        :first_name => :first_name,
        :last_name => :last_name,
        :email => :email,
        :name => :name }

    AdauthSearchField = [:login, :login]
end
