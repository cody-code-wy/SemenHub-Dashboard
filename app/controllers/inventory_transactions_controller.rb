class InventoryTransactionsController < ApplicationController

  def index
    @transaction_agregate = InventoryTransaction.select("min(id) as id, sum(quantity) as quantity_sum").group(:private, :semen_type, :price_per_unit, :semen_count, :animal_id, :storagefacility_id, :seller_id, :cost_per_unit)
    @transactions = @transaction_agregate.map{ |ta| InventoryTransaction.select("*, #{InventoryTransaction.sanitize ta.quantity_sum} as quantity").find(ta.id) }
  end

  def new
    @transaction = InventoryTransaction.new
  end

  def show
    @transaction = InventoryTransaction.find params[:id]
    @transactions = InventoryTransaction.where(private: @transaction.private, semen_type: @transaction.semen_type, price_per_unit: @transaction.price_per_unit, semen_count: @transaction.semen_count, animal_id: @transaction.animal_id, storagefacility_id: @transaction.storagefacility_id, seller_id: @transaction.seller_id, cost_per_unit: @transaction.cost_per_unit)
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
      :animal_id, :storagefacility_id, :seller_id
    )
  end

  def get_cost_per_unit
    return nil if params.require(:inventory_transaction).permit(:use_commission)[:use_commission] == "1"
    params.require(:inventory_transaction).permit(:cost_per_unit)[:cost_per_unit]
  end

  def put_data_in_transaction
    @transaction.animal = Animal.find(get_secondary_params[:animal_id])
    @transaction.storagefacility = StorageFacility.find(get_secondary_params[:storagefacility_id])
    @transaction.seller = User.find(get_secondary_params[:seller_id])
    @transaction.cost_per_unit = get_cost_per_unit
  end
end
