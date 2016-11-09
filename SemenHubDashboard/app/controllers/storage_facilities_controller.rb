class StorageFacilitiesController < ApplicationController

  def index
    @facilities = StorageFacility.all
  end

  def show
    @facility = StorageFacility.find(params[:id])
  end

  def new
    @facility = StorageFacility.new
  end

  def create
    @facility = StorageFacility.new(facility_params)

    put_address_in_facility(@facility)

    if(@facility.save)
      redirect_to @facility
    else
      render :new
    end
  end

  def edit
    @facility = StorageFacility.find(params[:id])
  end

  def update
    @facility = StorageFacility.find(params[:id])

    @facility.update(facility_params)

    put_address_in_facility(@facility)

    if @facility.save
      redirect_to @facility
    else
      render :new
    end

  end

  protected

  def facility_params
    params.require(:storage_facility).permit(:phone_number, :storage_fee, :release_fee, :website)
  end

  def address_params
    params.require(:storage_facility).require(:mailing_address).permit(
        :line1, :line2, :postal_code, :city, :region, :alpha_2
    )
  end

  def put_address_in_facility(facility)
    facility.address.update(address_params) if facility.address
    facility.address = Address.new(address_params) unless facility.address

    facility.address.validate

    facility
  end
end
