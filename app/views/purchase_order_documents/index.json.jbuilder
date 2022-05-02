json.array!(@purchase_order_documents) do |purchase_order_document|
  json.extract! purchase_order_document, :id, :document_title, :pdf_attachment, :purchase_order_id
  json.url purchase_order_document_url(purchase_order_document, format: :json)
end
