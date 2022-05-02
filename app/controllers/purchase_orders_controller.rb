class PurchaseOrdersController < ApplicationController
  before_action only: [:new, :create, :edit, :update, :destroy] do
    department("logistics")
  end
  before_action :set_purchase_order, only: [:show, :edit, :update, :destroy]
  before_action :cancel_session

  # GET /purchase_orders
  # GET /purchase_orders.json
  def index
    @purchase_orders = PurchaseOrder.all
  end

  # GET /purchase_orders/1
  # GET /purchase_orders/1.json
  def show
  end

  # GET /purchase_orders/new
  def new
    @purchase_order = PurchaseOrder.new
  end

  # GET /purchase_orders/1/edit
  def edit
  end

  # POST /purchase_orders
  # POST /purchase_orders.json
  def create
    @purchase_order = PurchaseOrder.new(purchase_order_params)

    respond_to do |format|
      if @purchase_order.save
        format.html { redirect_to @purchase_order, notice: 'Purchase order was successfully created.' }
        format.json { render :show, status: :created, location: @purchase_order }
      else
        format.html { render :new }
        format.json { render json: @purchase_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /purchase_orders/1
  # PATCH/PUT /purchase_orders/1.json
  def update
    respond_to do |format|
      if @purchase_order.update(purchase_order_params)
        format.html { redirect_to @purchase_order, notice: 'Purchase order was successfully updated.' }
        format.json { render :show, status: :ok, location: @purchase_order }
      else
        format.html { render :edit }
        format.json { render json: @purchase_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /purchase_orders/1
  # DELETE /purchase_orders/1.json
  def destroy
    @document_list = ""
    @msg = "Purchase order was successfully destroyed."
    @purchase_order_documents = PurchaseOrderDocument.where("purchase_order_id = ?", @purchase_order.id)

    if @purchase_order.purchase_order_documents.count > 0
      @msg = @msg + " The following documents were deleted:"
      #destroy each of the documents that belongs to this purchase order
      @purchase_order_documents.each do |pod|
        @msg = @msg + " " + pod.document_title + ","
        pod.destroy
      end
      @msg = @msg.chop!
      @msg = @msg + "."
    end

    @purchase_order.destroy
    respond_to do |format|
      format.html { redirect_to purchase_orders_url, notice: @msg }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_purchase_order
      @purchase_order = PurchaseOrder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def purchase_order_params
      params.require(:purchase_order).permit(:purchase_order_title, :client_id)
    end
end
