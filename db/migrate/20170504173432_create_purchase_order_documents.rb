class CreatePurchaseOrderDocuments < ActiveRecord::Migration
  def change
    create_table :purchase_order_documents do |t|
      t.string :document_title
      t.attachment :pdf_attachment
      t.references :purchase_order, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
