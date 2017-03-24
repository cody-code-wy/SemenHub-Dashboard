class LineItemsController < ApplicationController

  def new
    @line_item = LineItem.new
    @purchase = Purchase.find(params[:purchase_id])
  end

  def edit
    @line_item = LineItem.find(params[:id])
    @purchase = Purchase.find(params[:purchase_id])
  end

  def create
    @line_item = LineItem.new(line_item_params)
    @purchase = Purchase.find(params[:purchase_id])
    @line_item.purchase = @purchase
    if @line_item.save
      redirect_to @line_item.purchase
    else
      render 'new'
    end
  end

  def update
    @line_item = LineItem.find(params[:id])
    @purchase = Purchase.find(params[:purchase_id])
    if @line_item.update(line_item_params)
      redirect_to @line_item.purchase
    else
      render 'edit'
    end
  end

  def destroy
    @line_item = LineItem.find(params[:id])
    @line_item.destroy

    @purchase = Purchase.find(params[:purchase_id])
    redirect_to @purchase
  end

  private

  def line_item_params
    params.require(:line_item).permit(:name, :value)
  end
end
