class PurchaseOrderDocumentsController < ApplicationController
  #before_action :combine_documents, only: [:create, :update]
  before_action :find_purchase_order, except: [:combine_documents]
  before_action only: [:new, :create, :edit, :update, :destroy] do
    department("logistics")
  end
  before_action :set_purchase_order_document, only: [:show, :edit, :update, :destroy]

  #delete files from temporary folder
  before_action :empty_dir, only: [:new, :edit, :show, :index]
  layout false, :only => :combine_documents

  # GET /purchase_order_documents
  # GET /purchase_order_documents.json
  def index
    @purchase_order_documents = PurchaseOrderDocument.where("purchase_order_id = ?", session[:purchase_order_id])
  end

  # GET /purchase_order_documents/1
  # GET /purchase_order_documents/1.json
  def show
    @document = readDoc(@purchase_order_document.pdf_attachment.path)
  end

  # GET /purchase_order_documents/new
  def new
    @purchase_order_document = PurchaseOrderDocument.new({:purchase_order_id => session[:purchase_order_id]})
  end

  # GET /purchase_order_documents/1/edit
  def edit
  end

  # POST /purchase_order_documents
  # POST /purchase_order_documents.json
  def create
    @purchase_order_document = PurchaseOrderDocument.new(purchase_order_document_params)

    document_title = @purchase_order_document.document_title

    File.rename("C:/Sites/GreenInventory/public/temp/combined.pdf", "C:/Sites/GreenInventory/public/temp/"+document_title+".pdf")

    file_path = 'C:/Sites/GreenInventory/public/temp/'+ document_title +'.pdf'

    @purchase_order_document.file_from_url(file_path)

    respond_to do |format|
      if @purchase_order_document.save
        format.html { redirect_to @purchase_order_document, notice: 'Purchase order document was successfully created.' }
        format.json { render :show, status: :created, location: @purchase_order_document }
      else
        format.html { render :new }
        format.json { render json: @purchase_order_document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /purchase_order_documents/1
  # PATCH/PUT /purchase_order_documents/1.json
  def update
    document_title = @purchase_order_document.document_title

    File.rename("C:/Sites/GreenInventory/public/temp/combined.pdf", "C:/Sites/GreenInventory/public/temp/"+document_title+".pdf")

    file_path = 'C:/Sites/GreenInventory/public/temp/'+ document_title +'.pdf'

    @purchase_order_document.file_from_url(file_path)

    respond_to do |format|
      if @purchase_order_document.update(purchase_order_document_params)
        format.html { redirect_to @purchase_order_document, notice: 'Purchase order document was successfully updated.' }
        format.json { render :show, status: :ok, location: @purchase_order_document }
      else
        format.html { render :edit }
        format.json { render json: @purchase_order_document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /purchase_order_documents/1
  # DELETE /purchase_order_documents/1.json
  def destroy
    @purchase_order_document.pdf_attachment = nil
    @purchase_order_document.destroy
    respond_to do |format|
      format.html { redirect_to purchase_order_documents_url, notice: 'Purchase order document was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /purchase_order_documents/combine_documents
  def combine_documents
    #copy temporary file to a location
    @directory = "C:/Sites/GreenInventory/public/temp/"

    #if a file is added, then generate thumbnail from pdf
    if params[:file] then
      begin
        uploaded_io = params[:file].tempfile.path
        @file_name = params[:file].original_filename
        p uploaded_io

        files = Array.new

        FileUtils.cp(uploaded_io, @directory + @file_name)

        image=MiniMagick::Image.open(uploaded_io)
        image.format("png", 1)
        image.resize("200x200")
        image.write(@directory + @file_name+".png")
      end
      #else if a file must be removed, delete it from the temporary location
    elsif params[:remove] then 
      begin
        p "Deleting "+params[:remove]
        File.delete(@directory+params[:remove])
        File.delete(@directory+params[:remove]+".png")
      end
      #if the pages must be merged, merge them into combine.pdf
    elsif params[:combine] then 
      begin
        #Create a pdf object
        pdf = CombinePDF.new
        params[:pages].each do |k, v|
          p "page number is: " + k + " and file name is: "+ v

          #merge page into pdf object
          pdf << CombinePDF.load(@directory+v)
        end

        #Save pdf into the temporary directory
        pdf.save @directory+"combined.pdf"
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_purchase_order_document
      @purchase_order_document = PurchaseOrderDocument.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def purchase_order_document_params
      params.require(:purchase_order_document).permit(:document_title, :pdf_attachment, :purchase_order_id)
    end

    def find_purchase_order # sets a session containing the purchase order id to be available on every page in this controller.

      if session[:purchase_order_id] == nil then
        if params[:purchase_order_id] then
          @purchase_order = PurchaseOrder.find(params[:purchase_order_id])
          session[:purchase_order_id] = @purchase_order.id
          session[:purchase_order] = @purchase_order.purchase_order_title
        else
          flash[:warning] = 'Please select a purchase order'
          redirect_to :controller => 'purchase_orders', :action => 'index'
        end
      else
        @purchase_order = PurchaseOrder.find(session[:purchase_order_id])
      end
    end

    def empty_dir
      dir_path = "C:/Sites/GreenInventory/public/temp"
      Dir.foreach(dir_path) {|f| fn = File.join(dir_path, f); File.delete(fn) if f != '.' && f != '..'}
    end
end
