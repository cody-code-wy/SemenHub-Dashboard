class InventoryTransactionsController < ApplicationController

  def new
    @transaction = InventoryTransaction.new
  end
end
