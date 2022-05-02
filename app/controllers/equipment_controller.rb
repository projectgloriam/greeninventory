class EquipmentController < ApplicationController
  before_action :confirmed_logged_in
  before_action only: [:new, :create, :edit, :update, :destroy] do
    department("support")
  end
  before_action :find_specification, :except => [:simplesearch, :search, :searchresult, :search_params, :searchEngineWith12params]
  before_action :readonly, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_equipment, only: [:show, :edit, :update, :destroy]

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
    @specification = Specification.find(session[:specification_id])
    @document = readDoc(@specification.avatar.path)
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

    #forcing user to input serial number on the form
    if params[:serial_numbers] == "" then
      redirect_to :controller => 'equipment', :action => 'new'
      flash[:warning] = "Serial number(s) field cant be empty."
      return false
    else
      respond_to do |format|
        if @equipment.save
          serial_numbers = params[:serial_numbers].split(',')
          p serial_numbers.to_s

          serial_numbers.each { |serial| 
            @serial = Serial.new({:serial_number => serial, :equipment_id => @equipment.id })
            if @serial.save
              p 'Serial number: ' + @serial.serial_number + ' saved.'
            else
              redirect_to :controller => 'equipment', :action => 'new'
            end
          }

          format.html { redirect_to @equipment, notice: 'Equipment was successfully created.' }
          format.json { render :show, status: :created, location: @equipment }
        else
          autocomplete
          format.html { render :new }
          format.json { render json: @equipment.errors, status: :unprocessable_entity }
        end
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
    if spec.tested == "true" then
      redirect_to :controller => "equipment", :action => "index"
      flash[:warning] = "The specification's equipment have already been tested"
    elsif spec.equipment.count == 0 then
      redirect_to :controller => "equipment", :action => "index"
      flash[:warning] = "There are no equipment. Add them before you mark testing as complete"
    else
      if spec.update({:tested => true}) then
        AlertMailer.alert_email_reply(spec).deliver_later
        redirect_to controller: "equipment", action: "index"
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
      params.require(:equipment).permit(:equipment_name, :model, :engineer, :job_sheet_number, :technician_report, :specification_id)
    end


    def find_specification # sets a session containing the specification id to be available on every page in this controller.
      session[:equipment_id] = nil if session[:equipment_id]
      session[:equipment] = nil if session[:equipment]

      if session[:specification_id] == nil then
        p 'session specification is nil'
        if params[:equipment][:specification_id] then
          @specification = Specification.find(params[:equipment][:specification_id])
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
      "equipment.created_at LIKE '#{date}%'", {engineer: engineer}, {job_sheet_number: jobsheet} )

      specs = Equipment.joins(:specification).where.any_of({specifications: {case: case_number}},
      {specifications: {title: title}}, {specifications: {author: author}}, {specifications: {client: client}}, 
      {specifications: {contact_person: contact}}, {specifications: {email: email}}, {specifications: {supplier: supplier}} )

      serials = Equipment.joins(:serials).where(serials: {serial_number: serial})

      @equipment = Equipment.where.any_of(job, specs, serials).distinct
    end


end