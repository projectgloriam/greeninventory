class ProductsController < ApplicationController
  before_action :confirmed_logged_in
  before_action only: [:new, :create, :edit, :update, :destroy] do
    department("sales")
    #department("support")
  end
  
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  before_action :get_oem_logos, only: [:new, :create, :edit, :update]

  # GET /products
  # GET /products.json
  def index
    @products = Product.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  #POST /products/bulk
  def bulk
    if params[:table] then

      params[:table].each do |key, row|
        @product = Product.new

        @product.product_part_number = row[:PartNumber]
        @product.product_description = row[:Description]
        @product.product_price = row[:Price]
        
        row[:Category] = "OTHERS" if row[:Category] == ""
	      #Do a case-insensitive search for both foreign key records
	      @cat = ProductCategory.where('lower("category_name") = ?', row[:Category].downcase).first
	      
	      #if the category is not present, create a new one and fetch it again
	      if @cat == nil then 
	        @new_category = ProductCategory.new({:category_name => row[:Category]})

	        if @new_category.save 
	          @cat = ProductCategory.where('lower("category_name") = ?', row[:Category].downcase).first
	        end
	      end
	      @product.product_category_id = @cat.id


        row[:OriginalEquipmentManufacturer] = "OTHERS" if row[:OriginalEquipmentManufacturer] == ""
          #if the oem is not present, create a new one and fetch it again
          @oem = OemPartner.where('lower("OEM_name") = ?', row[:OriginalEquipmentManufacturer].downcase).first

          if @oem == nil then 
            @new_oem = OemPartner.new({:OEM_name => row[:OriginalEquipmentManufacturer]})

            if @new_oem.save 
              @oem = OemPartner.where('lower("OEM_name") = ?', row[:OriginalEquipmentManufacturer].downcase).first
            end
          end
          @product.oem_partner_id = @oem.id


        if row[:Distributor] != "" then
          #if the oem is not present, create a new one and fetch it again
          @dis = Distributor.where('lower("distributor_name") = ?', row[:Distributor].downcase).first

          if @dis == nil then 
            @new_dis = Distributor.new({:distributor_name => row[:Distributor], :currency => 'GHC', :fairgreen_price_formula => 'price'})

            if @new_dis.save 
              @dis = Distributor.where('lower("distributor_name") = ?', row[:Distributor].downcase).first
            end
          end

          p @dis.id
          @product.distributor_id = @dis.id
        end

        if @product.save
          p "Product '" + row[:Description] + "' with Part Number '" + row[:PartNumber] + "' has been saved."
        end
      end

      #@table = params[:table]
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:product_part_number, :product_description, :product_quantity, :product_price, :product_category_id, :oem_partner_id, :distributor_id)
    end

    def get_oem_logos
      @oem_partners = OemPartner.all
    end
end
