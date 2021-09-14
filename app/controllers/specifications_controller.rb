class SpecificationsController < ApplicationController
  before_action :confirmed_logged_in
  before_action :readonly, only: [:edit, :update, :destroy]
  before_action :set_specification, only: [:show, :edit, :update, :destroy]
  before_action only: [:new, :create, :edit, :update, :destroy] do
    #department("support")
    department("logistics")
  end
  before_action :cancel_session #cancels session containing specification id

  # GET /specifications
  # GET /specifications.json
  def index
    @specifications = Specification.order(created_at: :desc)

    @notifications = 0

    @specifications.each do |specs|
      @notifications += 1 if specs.tested == false
    end

    flash[:info] = "You have #{@notifications} jobs to test" if @notifications > 0
  end

  # GET /specifications/1
  # GET /specifications/1.json
  def show
  end

  # GET /specifications/new
  def new
    @specification = Specification.new
    autocomplete
  end

  # GET /specifications/1/edit
  def edit
  	autocomplete
  end

  # POST /specifications
  # POST /specifications.json
  def create
    autocomplete
    @specification = Specification.new(specification_params)
    @specification.case = Time.now.strftime("%Y%m%d%H%M%S")
    @specification.author = session[:user_name]
    @specification.tested = false

    respond_to do |format|
      if @specification.save
        AlertMailer.alert_email(@specification).deliver_later
        format.html { redirect_to @specification, notice: 'Specification was successfully created.' }
        format.json { render :show, status: :created, location: @specification }
      else
        format.html { render :new }
        format.json { render json: @specification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /specifications/1
  # PATCH/PUT /specifications/1.json
  def update
    autocomplete
    respond_to do |format|
      if @specification.update(specification_params)
        format.html { redirect_to @specification, notice: 'Specification was successfully updated.' }
        format.json { render :show, status: :ok, location: @specification }
      else
        format.html { render :edit }
        format.json { render json: @specification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /specifications/1
  # DELETE /specifications/1.json
  def destroy
    if @specification.tested == false then
	  @specification.avatar = nil
      @specification.destroy
      respond_to do |format|
        format.html { redirect_to specifications_url, notice: 'Specification was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      redirect_to specifications_url
      flash[:warning] = "Delete the specification's equipment and serial numbers before attempting to delete the specification"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_specification
      @specification = Specification.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def specification_params
      params.require(:specification).permit(:case, :title, :avatar, :client, :contact_person, :email, :telephone, :comment)
    end

end