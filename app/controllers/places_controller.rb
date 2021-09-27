class PlacesController < ApplicationController
  def new
    @place = Place.new
  end

  def create
    @place = Place.new(place_params)
    @place.save
    redirect_to blogs_path
  end

  def update
    @place = Place.find(params[:id])
    @place.update(place_params)
    redirect_to place_path(@place.id)
  end

  def show
    @place = Place.find(params[:id])
    gon.place = @place
  end

  private
  def place_params
    params.require(:place).permit(:address, :latitude, :longitude)
  end
end
