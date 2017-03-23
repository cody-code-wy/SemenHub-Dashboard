class LineItemsController < ApplicationController

  def new
    @line_item = LineItem.new
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

  private

  def line_item_params
    params.require(:line_item).permit(:name, :value)
  end
end
