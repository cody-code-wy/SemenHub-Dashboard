class SkusController < ApplicationController
  before_action :set_sku, only: [:show, :edit, :update, :destroy]

  # GET /skus
  # GET /skus.json
  def index
    @skus = Sku.select("#{Sku.table_name}.*, sum(quantity) as quantity_agg").joins(:inventory_transaction).group(:id).preload(:animal,:inventory_transaction,:storagefacility,seller: :commission)
 # @skus = Sku.select("#{Sku.table_name}.*, sum(quantity) as quantity_agg").joins(:inventory_transaction).group(:id).includes(:seller)
  end

  # GET /skus/1
  # GET /skus/1.json
  def show
  end

  # GET /skus/new
  def new
    @sku = Sku.new
    @sku.countries << Country.find_by_alpha_2('us')
  end

  # GET /skus/1/edit
  def edit
  end

  # POST /skus
  # POST /skus.json
  def create
    @sku = Sku.new(sku_params)

    respond_to do |format|
      if Country.where(alpha_2: country_params).count == country_params.count && @sku.save
        country_params.each do |alpha_2|
          @country = Country.find_by_alpha_2(alpha_2)
          @sku.countries << @country
        end

        format.html { redirect_to @sku, notice: 'Sku was successfully created.' }
        format.json { render :show, status: :created, location: @sku }
      else
        format.html { render :new }
        format.json { render json: @sku.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /skus/1
  # PATCH/PUT /skus/1.json
  def update
    respond_to do |format|
      if Country.where(alpha_2: country_params).count == country_params.count && @sku.update(sku_params)
        country_params.each do |alpha_2|
          @country = Country.find_by_alpha_2(alpha_2)
          @sku.countries << @country unless @sku.countries.include? @country
        end
        @sku.countries.delete(@sku.countries.where.not(alpha_2: country_params))

        format.html { redirect_to @sku, notice: 'Sku was successfully updated.' }
        format.json { render :show, status: :ok, location: @sku }
      else
        format.html { render :edit }
        format.json { render json: @sku.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /skus/1
  # DELETE /skus/1.json
  def destroy
    @sku.destroy
    respond_to do |format|
      format.html { redirect_to skus_url, notice: 'Sku was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sku
      @sku = Sku.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sku_params
      params.require(:sku).permit(:private, :semen_type, :semen_count, :price_per_unit, :animal_id, :storagefacility_id, :seller_id, :cost_per_unit, :cane_code, :has_percent)
    end

    def country_params
      out = params.require(:sku).permit(countries: [])[:countries]
      out ||= []
    end
end
