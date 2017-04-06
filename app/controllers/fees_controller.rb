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

    respond_to do |format|
      if @fee.save
        format.html { redirect_to @fee, notice: "Fee was successfully crated." }
        format.json { render :show, status: :created, location: @fee }
      else
        format.html { render :new }
        format.json { render json: @fee.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @fee = Fee.find(params[:id])
    @fee.update fee_params
    put_facility_in_fee

    respond_to do |format|
      if @fee.save
        format.html { redirect_to @fee, notice: "Fee was successfully updated." }
        format.json { render :show, status: :ok, location: @fee }
      else
        format.html { render :edit }
        format.json { render json: @fee.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @fee = Fee.find(params[:id])
    @fee.destroy
    respond_to do |format|
      format.html { redirect_to Fee}
      format.json { head :no_content }
    end
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
