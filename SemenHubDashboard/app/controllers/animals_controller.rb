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
    animal.breed.update(breed_params) if animal.breed
    animal.breed = Breed.find_or_create_by(breed_name: breed_params[:breed_id]) unless animal.breed

    animal.owner = User.find_by id: owner_params[:owner]
  end

  def animal_params
    params.require(:animal).permit(
      :name, :registration, :registration_type
    )
  end

  def breed_params
    params.require('animal').require('breed').permit('breed_id')
  end

  def owner_params
    params.require('animal').permit('owner')
  end
end
