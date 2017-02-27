class FeesController < ApplicationController

  def index
    @fees = Fee.all
  end

  def show
    @fee = Fee.find(params[:id])
  end

  def new
    @fee = Fee.new
  end

  def edit
    @fee = Fee.find(params[:id])
  end

  def create
    @fee = Fee.create fee_params
    put_facility_in_fee

    if @fee.save
      redirect_to @fee
    else
      render :new
    end
  end

  def update
    @fee = Fee.find(params[:id])
    
    @fee.update fee_params
    put_facility_in_fee

    if @fee.save
      redirect_to @fee
    else
      render :edit
    end
  end

  def destroy
    @fee = Fee.find(params[:id])
    @fee.destroy
    redirect_to Fee
  end

  protected

  def fee_params
    params.require(:fee).permit(
      :price, :fee_type, :storage_facility_id
    )
  end

  def put_facility_in_fee
    @fee.storage_facility = StorageFacility.find fee_params[:storage_facility_id]
  end

end
