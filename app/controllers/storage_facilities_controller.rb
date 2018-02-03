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
    StorageFacility.transaction do
      @facility = StorageFacility.new(facility_params)

      put_address_in_facility(@facility)

      if put_address_in_facility(@facility) && @facility.save
        redirect_to @facility
      else
        render :new
        raise ActiveRecord::Rollback
      end
    end
  end

  def edit
    @facility = StorageFacility.find(params[:id])
  end

  def update
    @facility = StorageFacility.find(params[:id])

    StorageFacility.transaction do
      @facility.update(facility_params)


      if put_address_in_facility(@facility) && @facility.save
        redirect_to @facility
      else
        render :new
        raise ActiveRecord::Rollback
      end
    end
  end

  def destroy
    @facility = StorageFacility.find(params[:id])
    @facility.destroy
    redirect_to StorageFacility
  end

  def test
    @source = StorageFacility.find(params[:storage_facility_id])
    @dest = StorageFacility.find(params[:dest])
    render json: @source.get_shipping_price(100, @dest)
  end

  protected

  def facility_params
    params.require(:storage_facility).permit(:phone_number, :website, :name, :email, :shipping_provider, :straws_per_shipment, :out_adjust, :in_adjust, :admin_required)
  end

  def address_params
    params.require(:storage_facility).require(:mailing_address).permit(
        :line1, :line2, :postal_code, :city, :region, :alpha_2
    )
  end

  def put_address_in_facility(facility)
    facility.address.update(address_params) if facility.address
    facility.address = Address.new(address_params) unless facility.address

    facility.address.valid?
  end
end
