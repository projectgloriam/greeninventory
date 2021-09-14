class EquipmentController < ApplicationController
  before_action :confirmed_logged_in
  before_action only: [:new, :create, :edit, :update, :destroy] do
    department("support")
  end
  before_action :readonly, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_equipment, only: [:show, :edit, :update, :destroy]
  before_action :find_specification, :except => [:simplesearch, :search, :searchresult, :search_params, :searchEngineWith12params]

  # GET /equipment
  # GET /equipment.json
  def index
    @equipment = Equipment.where("specification_id = ?", session[:specification_id])
  end

  # GET /equipment/1
  # GET /equipment/1.json
  def show
  end

  # GET /equipment/new
  def new
    autocomplete
    @equipment = Equipment.new({:specification_id => session[:specification_id]})
  end

  # GET /equipment/1/edit
  def edit
    autocomplete
  end

    # GET /equipment/simplesearch
  def simplesearch
    autocomplete #custom function: see below
  end
  
  # GET /equipment/search
  def search
    autocomplete #custom function: see below
  end
  
  # GET /equipment/searchresult
  def searchresult
    if params[:search] then
      searchEngineWith13params(params[:search],params[:search],params[:search],params[:search],params[:search],params[:search],params[:search],params[:search],params[:search],params[:search],params[:search],params[:search],params[:search])
    else
      searchEngineWith13params(params[:equipment],params[:model],params[:date],params[:engineer],params[:jobsheet],params[:supplier],params[:case],params[:title],params[:author],params[:client],params[:contact],params[:email],params[:serial])
    end
  end

  # POST /equipment
  # POST /equipment.json
  def create
    autocomplete
    @equipment = Equipment.new(equipment_params)
    @equipment.engineer = session[:user_name]

    respond_to do |format|
      if @equipment.save
        format.html { redirect_to @equipment, notice: 'Equipment was successfully created.' }
        format.json { render :show, status: :created, location: @equipment }
      else
        autocomplete
        format.html { render :new }
        format.json { render json: @equipment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /equipment/1
  # PATCH/PUT /equipment/1.json
  def update
    autocomplete
    respond_to do |format|
      if @equipment.update(equipment_params)
        format.html { redirect_to @equipment, notice: 'Equipment was successfully updated.' }
        format.json { render :show, status: :ok, location: @equipment }
      else
        autocomplete
        format.html { render :edit }
        format.json { render json: @equipment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /equipment/1
  # DELETE /equipment/1.json
  def destroy
  	if @equipment.serials.count == 0 then
    @equipment.destroy
	    respond_to do |format|
	      format.html { redirect_to equipment_index_url, notice: 'Equipment was successfully destroyed.' }
	      format.json { head :no_content }
	    end
    else
    	redirect_to equipment_index_url
    	flash[:warning] = "Delete equipment's serial number(s) before deleting the equipment"
    end
  end

  def tested
    spec = Specification.find(session[:specification_id])
    if spec.tested == true then
      redirect_to :controller => "specifications", :action => "index"
      flash[:warning] = "The specification's equipment have already been tested"
    elsif spec.equipment.count == 0 then
      redirect_to :controller => "specifications", :action => "index"
      flash[:warning] = "There are no equipment. Add them before you mark testing as complete"
    else
      if spec.update({:tested => true}) then
        AlertMailer.alert_email_reply(spec).deliver_later
        redirect_to controller: "specifications", action: "index"
        flash[:success] = "The specification has been tested successfully"
      end
    end
  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_equipment
      @equipment = Equipment.find(params[:id])
      @serials = @equipment.serials
      @quantity = @serials.count
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def equipment_params
      params.require(:equipment).permit(:equipment_name, :model, :engineer, :job_sheet_number, :supplier, :supplier_invoice_number, :technician_report, :supplier_Warranty_start, :supplier_Warranty_end, :customer_Warranty_start, :customer_Warranty_end, :specification_id)
    end


    def find_specification # sets a session containing the specification id to be available on every page in this controller.
      session[:equipment_id] = nil if session[:equipment_id]
      session[:equipment] = nil if session[:equipment]

      if session[:specification_id] == nil then
        if params[:specification_id] then
          @specification = Specification.find(params[:specification_id])
          session[:specification_id] = @specification.id
          session[:specification] = @specification.case
        else
          flash[:warning] = 'Please select a specification case'
          redirect_to :controller => 'specifications', :action => 'index'
        end
      else
        @specification = Specification.find(session[:specification_id])
      end
    end

    def searchEngineWith13params(equipment,model,date,engineer,jobsheet,supplier,case_number,title,author,client,contact,email,serial)
      #.any_of is a function of a third party gem downloaded from the web called "activerecord_any_of ".
      #Rails 4.2 doesn't support the .or function
      date = Date.parse(date) if date != ""
      rescue ArgumentError
      job = Equipment.where.any_of( {equipment_name: equipment}, {model: model}, 
      "equipment.created_at LIKE '#{date}%'", {engineer: engineer}, {job_sheet_number: jobsheet}, {supplier: supplier} )

      specs = Equipment.joins(:specification).where.any_of({specifications: {case: case_number}},
      {specifications: {title: title}}, {specifications: {author: author}}, {specifications: {client: client}}, 
      {specifications: {contact_person: contact}}, {specifications: {email: email}} )

      serials = Equipment.joins(:serials).where(serials: {serial_number: serial})

      @equipment = Equipment.where.any_of(job, specs, serials).distinct
      end
end
