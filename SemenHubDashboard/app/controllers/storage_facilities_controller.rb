class StorageFacilitiesController < ApplicationController

  def new
    @facility = StorageFacility.new
  end

  def create
    @facility = StorageFacility.new(facility_params)
  end
end
