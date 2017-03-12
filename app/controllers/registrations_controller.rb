class RegistrationsController < ApplicationController

  def index
    @regs = Registration.all
  end

  def show
    @reg = Registration.find(params[:id])
  end

  def new
    @reg = Registration.new
  end

  def edit
    @reg = Registration.find(params[:id])
  end

  def create
    @reg = Registration.new(reg_params)

    if @reg.save
      redirect_to @reg
    else
      render :new
    end
  end

  def update
    @reg = Registration.find(params[:id])

    if @reg.update(reg_params)
      redirect_to @reg
    else
      render :edit
    end
  end

  protected

  def reg_params
    params.require(:registration).permit(:registrar_id, :animal_id, :registration, :ai_certification, :note)
  end

end
