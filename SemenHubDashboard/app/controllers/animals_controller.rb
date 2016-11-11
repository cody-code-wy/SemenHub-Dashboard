class AnimalsController < ApplicationController

  def index
    @animals = Animal.all
  end

  def show
    @animal = Animal.find(params[:id])
  end

  def new
    @animal = Animal.new
  end

  def edit
    @animal = Animal.find(params[:id])
  end

  def create
    @animal = Animal.new(animal_params)

    if @animal.save
      redirect_to @animal
    else
      render :new
    end
  end

  protected

  def animal_params
    params.require(:animal).permit(
      :name, :registration, :registration_type, :owner, :breed
    )
  end
end
