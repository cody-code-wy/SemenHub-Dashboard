class LineItemsController < ApplicationController

  before_action :set_line_item, except: [:new, :create]
  before_action :set_purchase
  before_action :check_purchase

  def new
    @line_item = LineItem.new
  end

  def edit
  end

  def create
    @line_item = LineItem.new(line_item_params)
    @line_item.purchase = @purchase
    if @line_item.save
      redirect_to @line_item.purchase
    else
      render 'new'
    end
  end

  def update
    if @line_item.update(line_item_params)
      redirect_to @line_item.purchase
    else
      render 'edit'
    end
  end

  def destroy
    @line_item.destroy

    redirect_to @purchase
  end

  private

  def set_line_item
    @line_item = LineItem.find(params[:id])
  end

  def set_purchase
    @purchase = Purchase.find(params[:purchase_id])
  end

  def check_purchase
    unless @purchase.mutable?
      flash[:alert] = "Line Items on this purchase cannot be changed. Please put the purchase in administrative mode first"
      redirect_to @purchase
    end
  end

  def line_item_params
    params.require(:line_item).permit(:name, :value)
  end
end
