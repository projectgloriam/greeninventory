class OemPartnersController < ApplicationController
  before_action :confirmed_logged_in
  before_action only: [:new, :create, :edit, :update, :destroy] do
    #department("support")
    department("sales")
  end
  before_action :set_oem_partner, only: [:show, :edit, :update, :destroy]

  # GET /oem_partners
  # GET /oem_partners.json
  def index
    @oem_partners = OemPartner.order(:OEM_logo_file_name)
  end

  # GET /oem_partners/1
  # GET /oem_partners/1.json
  def show
  end

  # GET /oem_partners/new
  def new
    @oem_partner = OemPartner.new
  end

  # GET /oem_partners/1/edit
  def edit
  end

  # POST /oem_partners
  # POST /oem_partners.json
  def create
    @oem_partner = OemPartner.new(oem_partner_params)

    #respond_to do |format|
      if @oem_partner.save
        redirect_to new_product_path
        #format.html { redirect_to @oem_partner, notice: 'Oem partner was successfully created.' }
        #format.json { render :show, status: :created, location: @oem_partner }
      else
        render "new"
        #format.html { render :new }
        #format.json { render json: @oem_partner.errors, status: :unprocessable_entity }
      end
    #end
  end

  # PATCH/PUT /oem_partners/1
  # PATCH/PUT /oem_partners/1.json
  def update
    respond_to do |format|
      if @oem_partner.update(oem_partner_params)
        format.html { redirect_to @oem_partner, notice: 'Oem partner was successfully updated.' }
        format.json { render :show, status: :ok, location: @oem_partner }
      else
        format.html { render :edit }
        format.json { render json: @oem_partner.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /oem_partners/1
  # DELETE /oem_partners/1.json
  def destroy
    @oem_partner.destroy
    respond_to do |format|
      format.html { redirect_to oem_partners_url, notice: 'Oem partner was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_oem_partner
      @oem_partner = OemPartner.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def oem_partner_params
      params.require(:oem_partner).permit(:OEM_name, :OEM_logo)
    end
end