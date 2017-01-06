class InventoryTransactionsController < ApplicationController

  def new
    @transaction = InventoryTransaction.new
  end

  def create
    @transaction = InventoryTransaction.new(get_params)

    put_data_in_transaction

    if @transaction.save
      redirect_to @transaction
    else
      render :new
    end
  end

  def edit
    @transaction = InventoryTransaction.find params[:id]
  end

  protected

  def get_params
    params.require(:inventory_transaction).permit(
      :quantity, :private, :semen_type, :price_per_unit, :semen_count, :semen_count
    )
  end

  def get_secondary_params
    params.require(:inventory_transaction).permit(
      :animal, :storageFacility
    )
  end

  def put_data_in_transaction
    @transaction.animal = Animal.find(get_secondary_params[:animal])
    @transaction.storageFacility = StorageFacility.find(get_secondary_params[:storageFacility])
  end
end
