class InventoryTransactionsController < ApplicationController

  def index
    @transactions = InventoryTransaction.select('*, sum(quantity) as quantity').group(:private, :semen_type, :price_per_unit, :semen_count, :animal_id, :storageFacility_id, :seller_id)
  end

  def new
    @transaction = InventoryTransaction.new
  end

  def show
    @transaction = InventoryTransaction.find params[:id]
    @transactions = InventoryTransaction.where(private: @transaction.private, semen_type: @transaction.semen_type, price_per_unit: @transaction.price_per_unit, semen_count: @transaction.semen_count, animal_id: @transaction.animal_id, storageFacility_id: @transaction.storageFacility_id, seller_id: @transaction.seller_id)
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

  def update
    @transaction = InventoryTransaction.find params[:id]

    @transaction.update get_params

    put_data_in_transaction

    if @transaction.save
      redirect_to @transaction
    else
      render :edit
    end
  end

  protected

  def get_params
    params.require(:inventory_transaction).permit(
      :quantity, :private, :semen_type, :price_per_unit, :semen_count, :semen_count
    )
  end

  def get_secondary_params
    params.require(:inventory_transaction).permit(
      :animal_id, :storageFacility_id, :seller_id
    )
  end

  def get_cost_per_unit
    return nil if params.require(:inventory_transaction).permit(:use_commission)[:use_commission] == "1"
    params.require(:inventory_transaction).permit(:cost_per_unit)[:cost_per_unit]
  end

  def put_data_in_transaction
    @transaction.animal = Animal.find(get_secondary_params[:animal_id])
    @transaction.storageFacility = StorageFacility.find(get_secondary_params[:storageFacility_id])
    @transaction.seller = User.find(get_secondary_params[:seller_id])
    @transaction.cost_per_unit = get_cost_per_unit
  end
end
