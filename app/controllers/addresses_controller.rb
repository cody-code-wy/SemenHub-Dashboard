class AddressesController < ApplicationController
  before_action :set_address, only: [:show]

  def show
  end

  private

  def set_address
    @address = Address.find(params[:id])
  end
end
