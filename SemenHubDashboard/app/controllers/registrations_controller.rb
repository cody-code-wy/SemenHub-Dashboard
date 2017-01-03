class RegistrationsController < ApplicationController

  def index
    @regs = Registration.all
  end

  def show
    @reg = Registration.find(params[:id])
  end

  def add_animal
    render :add_animal
  end

  def add_animal_post
    animal = Animal.find(add_animal_params[:id])
    registration = Registration.find(add_reg_params[:id])
    registration.animal = animal unless animal.nil?
    registration.save

    redirect_to registration
  end

  def new
    @reg = Registration.new
  end

  def create
    @reg = Registration.new(reg_params)

    if (@reg.save)
      redirect_to @reg
    else
      render :new
    end
  end

  protected

  def add_animal_params
    params.require(:animal_id).permit(:id)
  end

  def add_reg_params
    params.permit(:id)
  end

  def reg_params
    params.require(:registration).permit(:registrar_id, :registration, :note)
  end

end
