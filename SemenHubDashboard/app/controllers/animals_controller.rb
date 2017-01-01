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

    put_data_in_animal(@animal)

    if @animal.save
      redirect_to @animal
    else
      render :new
    end
  end

  def destroy
    @animal = Animal.find(params[:id])
    @animal.destroy
    redirect_to Animal
  end

  protected

  def put_data_in_animal(animal)
    animal.owner = User.find_by id: owner_params[:owner]
  end

  def animal_params
    params.require(:animal).permit(
      :name
    )
  end

  def owner_params
    params.require('animal').permit('owner')
  end
end
