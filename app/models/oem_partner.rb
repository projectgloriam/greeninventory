class OemPartner < ActiveRecord::Base
	has_many :products
	validates_presence_of :OEM_name
	has_attached_file :OEM_logo, :styles => { :thumb => "100x100#", :small  => "56x40>", :medium => "200x200" }, :default_url => "/images/:style/OEM.png"
	validates_attachment_content_type :OEM_logo, content_type: /\Aimage\/.*\z/
	#validates_with AttachmentPresenceValidator, attributes: :OEM_logo
end