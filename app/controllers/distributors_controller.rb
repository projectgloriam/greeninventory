class DistributorsController < ApplicationController
  before_action :set_distributor, only: [:show, :edit, :update, :destroy]
  before_action only: [:new, :create, :edit, :update, :destroy] do
    department("sales")
    #department("support")
  end

  # GET /distributors
  # GET /distributors.json
  def index
    @distributors = Distributor.all
  end

  # GET /distributors/1
  # GET /distributors/1.json
  def show
  end

  # GET /distributors/new
  def new
    @distributor = Distributor.new
  end

  # GET /distributors/1/edit
  def edit
  end

  # POST /distributors
  # POST /distributors.json
  def create
    @distributor = Distributor.new(distributor_params)

    @distributor.fairgreen_price_formula = "price * 1.13" if @distributor.fairgreen_price_formula == ""

    @distributor.currency = "GHc" if @distributor.currency == ""
    
    #respond_to do |format|
      if @distributor.save
        redirect_to new_product_path
        #format.html { redirect_to @distributor, notice: 'Distributor was successfully created.' }
        #format.json { render :show, status: :created, location: @distributor }
      else
        render "new"
        #format.html { render :new }
        #format.json { render json: @distributor.errors, status: :unprocessable_entity }
      end
    #end
  end

  # PATCH/PUT /distributors/1
  # PATCH/PUT /distributors/1.json
  def update
    respond_to do |format|
      if @distributor.update(distributor_params)
        format.html { redirect_to @distributor, notice: 'Distributor was successfully updated.' }
        format.json { render :show, status: :ok, location: @distributor }
      else
        format.html { render :edit }
        format.json { render json: @distributor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /distributors/1
  # DELETE /distributors/1.json
  def destroy
    @distributor.destroy
    respond_to do |format|
      format.html { redirect_to distributors_url, notice: 'Distributor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_distributor
      @distributor = Distributor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def distributor_params
      params.require(:distributor).permit(:distributor_name, :currency, :fairgreen_price_formula)
    end
end
