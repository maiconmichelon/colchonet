class RoomsController < ApplicationController
  PER_PAGE = 1

  before_action :require_authentication,
  only: [:new, :edit, :create, :update, :destroy]

 def index
    @search_query = params[:q]
      rooms = Room.search(@search_query).
        page(params[:page]).
        per(PER_PAGE)
    @rooms = RoomCollectionPresenter.new(rooms.most_recent, self)
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
    room_model = Room.friendly.find(params[:id])
    @room = RoomPresenter.new(room_model, self)
  end

  # GET /rooms/new
  def new
    @room = current_user.rooms.build
  end

  # GET /rooms/1/edit
  def edit
    @room = current_user.rooms.friendly.find(params[:id])
  end

  # POST /rooms
  # POST /rooms.json
  def create
    @room = current_user.rooms.build room_params

    respond_to do |format|
      if @room.save
        format.html { redirect_to @room, notice: t('flash.notice.room_created') }
        format.json { render action: 'show', status: :created, location: @room }
       else
        format.html { render action: 'new' }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rooms/1
  # PATCH/PUT /rooms/1.json
  def update
    respond_to do |format|
      @room = current_user.rooms.friendly.find(params[:id])

      if @room.update(room_params)
        format.html { redirect_to @room, notice: t('flash.notice.room_updated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    @room = current_user.rooms.friendly.find(params[:id])
    @room.destroy
    respond_to do |format|
      format.html { redirect_to rooms_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      params.require(:room).permit(:title, :location, :description, :picture)
    end
end
