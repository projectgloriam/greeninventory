class SerialsController < ApplicationController
  before_action :confirmed_logged_in
  before_action only: [:new, :create, :edit, :update, :destroy] do
    department("support")
  end
  before_action :readonly, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_serial, only: [:show, :edit, :update, :destroy]
  before_action :find_equipment

  # GET /serials
  # GET /serials.json
  def index
    #@serials = Serial.all
    @serials = Serial.where("equipment_id = ?", session[:equipment_id])
    flash[:default] = 'Use RFID scanner (Optional): Serial number will be automatically added to the list.'
    @icon = '<span class="mif-qrcode"></span>'
    @icon = @icon.html_safe
  end

  # GET /serials/1
  # GET /serials/1.json
  def show
  end

  # GET /serials/new
  def new
    @serial = Serial.new({:equipment_id => session[:equipment_id]})
  end

  # GET /serials/1/edit
  def edit
  end

  # POST /serials
  # POST /serials.json
  def create
    @serial = Serial.new(serial_params)

    respond_to do |format|
      if @serial.save
        format.html { redirect_to @serial, notice: 'Serial was successfully created.' }
        format.json { render :show, status: :created, location: @serial }
        format.js
      else
        format.html { render :new }
        format.json { render json: @serial.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /serials/1
  # PATCH/PUT /serials/1.json
  def update
    respond_to do |format|
      if @serial.update(serial_params)
        format.html { redirect_to @serial, notice: 'Serial was successfully updated.' }
        format.json { render :show, status: :ok, location: @serial }
      else
        format.html { render :edit }
        format.json { render json: @serial.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /serials/1
  # DELETE /serials/1.json
  def destroy
    @serial.destroy
    respond_to do |format|
      format.html { redirect_to serials_url, notice: 'Serial was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_serial
      @serial = Serial.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def serial_params
      params.require(:serial).permit(:serial_number, :equipment_id)
    end

    def find_equipment # sets a session containing the equipment id to be available on every page in this controller.
      if session[:equipment_id] == nil then
        if params[:equipment_id] then
          @equipment = Equipment.find(params[:equipment_id])
          session[:equipment_id] = @equipment.id
          session[:equipment] = @equipment.equipment_name
        else
          flash[:notice] = 'Please select a specification case'
          redirect_to :controller => 'specifications', :action => 'index', :err => 'alert'
        end
      else
        @equipment = Equipment.find(session[:equipment_id])
      end
    end
end
