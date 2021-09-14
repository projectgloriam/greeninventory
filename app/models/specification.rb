class Specification < ActiveRecord::Base
	has_attached_file :avatar, :style => { :thumb => "100x100", :small  => "150x150", :medium => "200x200" }, :default_url => "/images/:style/missing.png"
	  #validate content type
	  #validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
	validates_attachment :avatar, :content_type => {:content_type => %w(image/jpeg image/jpg image/png application/pdf application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document)}
	  #validate filename
	  #validates_attachment_file_name :avatar, :matches => [/png\Z/, /jpe?g\Z/]

	  # Explicitly do not validate
	  #do_not_validate_attachment_file_type :avatar

	  validates_with AttachmentPresenceValidator, attributes: :avatar
	  EMAIL_REGEX = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i
	  validates_presence_of :title
	  validates_presence_of :client
	  validates_presence_of :contact_person
	  validates :email, :presence => true,
	  					:format => {:with => EMAIL_REGEX, :message => 'It must be a valid email address'}
	  validates :telephone, :numericality => {:message => 'It must be a valid telephone number'}


  	include PublicActivity::Model
  	tracked owner: Proc.new{ |controller, model| controller.current_user ? controller.current_user : nil }

  	has_many :equipment
end
