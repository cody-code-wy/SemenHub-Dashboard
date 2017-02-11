class AnimalsController < ApplicationController

  def index
    @animals = Animal.all
  end

  def show
    @animal = Animal.find(params[:id])
    @transactions_agregate = @animal.inventory_transactions.select('max(id) as id, sum(quantity) as quantity_sum').where("quantity > ?", 0).group(:private, :semen_type, :price_per_unit, :semen_count, :storageFacility_id, :seller_id)
    @transactions = @transactions_agregate.map{ |ta| InventoryTransaction.select("*, #{Animal.sanitize ta.quantity_sum} as quantity").find(ta.id) }
  end

  def new
    @animal = Animal.new
  end

  def edit
    @animal = Animal.find(params[:id])
  end

  def create
    @animal = Animal.new(animal_params)

    put_data_in_animal

    if @animal.save
      redirect_to @animal
    else
      render :new
    end
  end

  def update
    @animal = Animal.find(params[:id])

    @animal.update(animal_params)
    put_data_in_animal

    if @animal.save
      redirect_to @animal
    else
      render :edit
    end
  end

  def destroy
    @animal = Animal.find(params[:id])
    @animal.destroy
    redirect_to Animal
  end

  protected

  def put_data_in_animal
    @animal.owner = User.find animal_params[:owner_id]
  end

  def animal_params
    params.require(:animal).permit(
      :name, :owner_id, :breed_id, :private_herd_number, :ai_certification, :dna_number
    )
  end

end
