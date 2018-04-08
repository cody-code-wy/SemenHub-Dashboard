class AnimalsController < ApplicationController
  protect_from_forgery except: :repl

  def secure
    not (["repl"].include?(params[:action]))
  end

  def index
    @animals = Animal.all.preload(:owner, :registrations)
    @breeds = Breed.all.preload(:registrars)
  end

  def show
    @animal = Animal.find(params[:id])
    @skus = Sku.where(animal: @animal)
  end

  def repl
    response.content_type = 'text/javascript' if params[:callback]
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

    put_data_in_animal
    put_registrations

    if @animal.save
      redirect_to @animal
    else
      render :new
    end
  end

  def update
    @animal = Animal.find(params[:id])

    @animal.update(animal_params)
    put_data_in_animal
    put_registrations

    if @animal.save
      redirect_to @animal
    else
      render :edit
    end
  end

  def destroy
    @animal = Animal.find(params[:id])
    @animal.destroy
    redirect_to Animal
  end

  protected

  def put_data_in_animal
    @animal.owner = User.find animal_params[:owner_id]
  end

  def animal_params
    params.require(:animal).permit(
      :name, :description, :notes, :owner_id, :breed_id, :private_herd_number, :dna_number, :is_male, :dam_id, :sire_id
    )
  end

  def registration_params (registrar)
    params.require(:registrations).require(registrar.name.parameterize).permit(:registration, :ai_certification).merge({registrar: registrar})
  end

  def put_registrations
    @animal.breed.registrars.each do |registrar|
      registration = @animal.registrations.where(registrar: registrar).first #there should only be one!
      registration ||= Registration.new()
      registration.assign_attributes registration_params(registrar)
      unless registration.registration.empty? && registration.ai_certification.empty?
        @animal.registrations << registration
      else
        registration.destroy!
      end
    end
  end

end
