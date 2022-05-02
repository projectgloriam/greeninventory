class PurchaseOrder < ActiveRecord::Base
  belongs_to :client
  has_many :purchase_order_documents

  validates_presence_of :purchase_order_title
end
