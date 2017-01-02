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

  def reg_params
    params.require(:registration).permit(:registrar_id, :registration, :note)
  end

end
