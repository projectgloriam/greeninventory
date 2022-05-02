class LeavesController < ApplicationController
  before_action :confirmed_logged_in
  before_action :set_leafe, only: [:show, :edit, :update, :destroy]
  before_action :individual_access

  # GET /leaves
  # GET /leaves.json
  def index
    #checking access of the user
    case access_level(session[:user_name])
    when 1
      #only take every leave he has done so far
      @leaves = Leave.where(staff_name: session[:user_name])
    when 2
      #only take the leaves in the person's department
      group = session[:group]
      query = ""
      group.each_with_index do |area, index|
        query = query + "department LIKE '%" + area + "%'"
        query = query + " OR " if index != (group.length-1)
      end

      @leaves = Leave.where(query)
    when 3
      #see all the leaves
      @leaves = Leave.all
    else 
      redirect_to controller: 'welcome', action:'index'
    end 
  end

  # GET /leaves/1
  # GET /leaves/1.json
  def show
  end

  # GET /leaves/new
  def new
    redirect_to action:'index'
    #@leafe = Leave.new
  end

  # GET /leaves/1/edit
  def edit
  end

  # POST /leaves
  # POST /leaves.json
  def create
    @leafe = Leave.new(leafe_params)
    department = session[:group]
    @leafe.staff_name = session[:user_name]
    @leafe.username = session[:login]
    @leafe.department = department.join(",")

    respond_to do |format|
      if @leafe.save
        #send mail
        AlertMailer.leave_email(@leafe).deliver_later
        format.html { redirect_to @leafe, notice: 'Leave was successfully created.' }
        format.json { render :show, status: :created, location: @leafe }
      else
        format.html { render :new }
        format.json { render json: @leafe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /leaves/1
  # PATCH/PUT /leaves/1.json
  def update
    respond_to do |format|
      if @leafe.update(leafe_params)
        #send mail
        AlertMailer.leave_email(@leafe).deliver_later
        format.html { redirect_to @leafe, notice: 'Leave was successfully updated.' }
        format.json { render :show, status: :ok, location: @leafe }
      else
        format.html { render :edit }
        format.json { render json: @leafe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /leaves/1
  # DELETE /leaves/1.json
  def destroy
    @leafe.destroy
    respond_to do |format|
      format.html { redirect_to leaves_url, notice: 'Leave was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_leafe
      @leafe = Leave.find(params[:id])

      #checking access of the user
      case access_level(session[:user_name])
      when 1
        #check if its the same user else redirect
        redirect_to action:'index' if session[:user_name] != @leafe.staff_name
      when 2
        #get array of departments from the string
        staff_departments = @leafe.department.split(",")
        authorizer_departments = session[:group]
        in_common = authorizer_departments - staff_departments

        #check if authorizer's department is in the user's department 
        #by subtracting the two arrays and seeing if they have some departments in common
        redirect_to action:'index' if in_common.length < 1
        @authorizer_level = 2
      when 3
        #else it can be the CEO and CTO: give access
        @authorizer_level = 3
      else
        redirect_to action:'index'
      end 
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def leafe_params
      params.require(:leafe).permit(:staff_name, :username, :department, :commencement_date, :resumption_date, :days_applied_for, :vacation_address, :authorizer, :final_authorizer)
    end
end