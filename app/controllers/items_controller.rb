class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :authorized_user, only: [:edit, :update, :destroy]
  before_filter :authenticate_user!, :except => [:index, :show]

  # GET /items
  # GET /items.json
  def index
    @items = current_user.items.all
  end

  # GET /items/1
  # GET /items/1.json
  def show
    @hash = Gmaps4rails.build_markers(@item) do |item, marker|
      marker.lat item.latitude
      marker.lng item.longitude
    end
  end

  # GET /items/new
  def new
    @item = current_user.items.build
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    @item = current_user.items.build(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    respond_to do |format|
      if(params[:item][:completed_date])
        completed_date = params[:item][:completed_date]
        completed_year = completed_date[:year].to_i
        completed_month = completed_date[:month].to_i
        completed_day = completed_date[:day].to_i
        params[:item][:completed_date] = Date.new(completed_year, completed_month, completed_day)
      end

      if @item.update(item_params)
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url, notice: 'Item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:title, :description, :location, :completed, :importance, :user_id, :image, :completed_date, :latitude, :longitude)

    end

    def authorized_user
      @item = current_user.items.find_by(id: params[:id])
      redirect_to items_path, notice: "Not authorized to edit this item" if @item.nil?
    end
end
