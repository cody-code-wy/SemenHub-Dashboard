class InventoryTransactionsController < ApplicationController

  def index
    @transactions = InventoryTransaction.all
  end

  def new
    @transaction = InventoryTransaction.new
    if params[:sku_id]
      @transaction.sku = Sku.find(params[:sku_id])
    else
      @transaction.sku = Sku.new
    end
  end

  def show
    @transaction = InventoryTransaction.find(params[:id])
  end

  def create
    @transaction = InventoryTransaction.new(get_params.merge(sku: get_sku))
    if @transaction.save and @transaction.sku.valid?
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
    @transaction.update(get_params.merge(sku: get_sku))
    if @transaction.save and @transaction.sku.valid?
      redirect_to @transaction
    else
      render :edit
    end
  end

  protected

  def get_params
    params.require(:inventory_transaction).permit(:quantity)
  end

  def get_sku
    sku_params = params.require(:inventory_transaction).require(:sku).permit(:private, :semen_type, :semen_count, :price_per_unit, :animal_id, :storagefacility_id, :seller_id, :cost_per_unit, :cane_code, :has_percent)
    sku_params.transform_values! { |value| value == "" ? nil : value }
    Sku.find_or_create_by(sku_params)
  end

end
