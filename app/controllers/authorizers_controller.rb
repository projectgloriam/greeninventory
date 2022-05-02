class AuthorizersController < ApplicationController
  before_action :confirmed_logged_in
  before_action do
    department("Domain Admins")
  end
  before_action :set_authorizer, only: [:show, :edit, :update, :destroy]

  # GET /authorizers
  # GET /authorizers.json
  def index
    @authorizers = Authorizer.all
  end

  # GET /authorizers/1
  # GET /authorizers/1.json
  def show
  end

  # GET /authorizers/new
  def new
    @authorizer = Authorizer.new
  end

  # GET /authorizers/1/edit
  def edit
  end

  # POST /authorizers
  # POST /authorizers.json
  def create
    @authorizer = Authorizer.new(authorizer_params)

    respond_to do |format|
      if @authorizer.save
        format.html { redirect_to @authorizer, notice: 'Authorizer was successfully created.' }
        format.json { render :show, status: :created, location: @authorizer }
      else
        format.html { render :new }
        format.json { render json: @authorizer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /authorizers/1
  # PATCH/PUT /authorizers/1.json
  def update
    respond_to do |format|
      if @authorizer.update(authorizer_params)
        format.html { redirect_to @authorizer, notice: 'Authorizer was successfully updated.' }
        format.json { render :show, status: :ok, location: @authorizer }
      else
        format.html { render :edit }
        format.json { render json: @authorizer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /authorizers/1
  # DELETE /authorizers/1.json
  def destroy
    @authorizer.destroy
    respond_to do |format|
      format.html { redirect_to authorizers_url, notice: 'Authorizer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_authorizer
      @authorizer = Authorizer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def authorizer_params
      params.require(:authorizer).permit(:full_name, :username, :department, :level)
    end
end
