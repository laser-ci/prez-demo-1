class WombatsController < ApplicationController
  before_action :set_wombat, only: [:show, :edit, :update, :destroy]

  # GET /wombats
  # GET /wombats.json
  def index
    @wombats = Wombat.all
  end

  # GET /wombats/1
  # GET /wombats/1.json
  def show
  end

  # GET /wombats/new
  def new
    @wombat = Wombat.new
  end

  # GET /wombats/1/edit
  def edit
  end

  # POST /wombats
  # POST /wombats.json
  def create
    @wombat = Wombat.new(wombat_params)

    respond_to do |format|
      if @wombat.save
        format.html { redirect_to @wombat, notice: 'Wombat was successfully created.' }
        format.json { render :show, status: :created, location: @wombat }
      else
        format.html { render :new }
        format.json { render json: @wombat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wombats/1
  # PATCH/PUT /wombats/1.json
  def update
    respond_to do |format|
      if @wombat.update(wombat_params)
        format.html { redirect_to @wombat, notice: 'Wombat was successfully updated.' }
        format.json { render :show, status: :ok, location: @wombat }
      else
        format.html { render :edit }
        format.json { render json: @wombat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wombats/1
  # DELETE /wombats/1.json
  def destroy
    @wombat.destroy
    respond_to do |format|
      format.html { redirect_to wombats_url, notice: 'Wombat was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wombat
      @wombat = Wombat.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def wombat_params
      params.require(:wombat).permit(:title, :body, :published)
    end
end
