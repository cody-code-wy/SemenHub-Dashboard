class InventoryTransactionsController < ApplicationController

  def index
    @skus = Sku.all
  end

  def new
    @transaction = InventoryTransaction.new
    @transaction.sku = Sku.new
  end

  def show
    @sku = Sku.find params[:id]
  end

  def create
    @transaction = InventoryTransaction.new(get_params)

    @transaction.sku = Sku.find_or_initialize_by(get_sku_params)

    if @transaction.save and @transaction.sku.valid?
      redirect_to inventory_transaction_url id: @transaction.sku.id
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
    @transaction.sku = Sku.find_or_initialize_by(get_sku_params)

    if @transaction.save and @transaction.sku.valid?
      redirect_to inventory_transaction_url id: @transaction.sku.id
    else
      render :edit
    end
  end

  protected

  def get_params
    params.require(:inventory_transaction).permit(
      :quantity
    )
  end

  def get_sku_params
    sku_params = params.require(:inventory_transaction).require(:sku).permit(
      :private, :semen_type, :price_per_unit, :semen_count, :animal_id, :storagefacility_id, :seller_id
    ).merge({cost_per_unit: get_cost_per_unit}) #get the whole params
    sku_params[:price_per_unit] = sku_params[:price_per_unit].to_i != 0 ? sku_params[:price_per_unit] : nil
    sku_params
  end

  def get_cost_per_unit
    return nil if params.require(:inventory_transaction).require(:sku).permit(:use_commission)[:use_commission] == "1"
    params.require(:inventory_transaction).require(:sku).permit(:cost_per_unit)[:cost_per_unit]
  end

end
