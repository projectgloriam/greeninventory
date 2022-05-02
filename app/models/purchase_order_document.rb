#for retrieving the image from the remote url
require 'open-uri' 

class PurchaseOrderDocument < ActiveRecord::Base
	has_attached_file :pdf_attachment
	validates_attachment :pdf_attachment, content_type: { content_type: "application/pdf" }
	validates_with AttachmentPresenceValidator, attributes: :pdf_attachment
	validates_presence_of :document_title
	belongs_to :purchase_order

	#pull the image from the remote url and assign it as the avatar
	def file_from_url(url)
		self.pdf_attachment = open(url)
	end
end