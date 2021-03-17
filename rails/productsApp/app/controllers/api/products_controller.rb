class Api::ProductsController < ApplicationController
  before_action :set_product, except: [:index, :create]

  # GET /products.xml
  # GET /products.json
  def index
    @products = Product.order(created_at: :desc)
  
    respond_to do |format|
      format.json { render json: @products.map(&:to_api) }
      format.xml { render xml: @products.map(&:to_api) }
    end
  end

  # GET /products/1.xml
  # GET /products/1.json
  def show
    respond_to do |format|
      format.json { render json: @product.to_api }
      format.xml { render xml: @product.to_api }
    end
  end

  # POST /products.xml
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.json { render json: @product.to_api, status: :created, location: @product }
        format.xml { render xml: @product.to_api, status: :created, location: @product }
      else
        format.json { render json: @product.errors, status: :unprocessable_entity }
        format.xml { render xml: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1.xml
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.json { render json: @product.to_api, status: :ok, location: @product }
        format.xml { render xml: @product.to_api, status: :ok, location: @product }
      else
        format.json { render json: @product.errors, status: :unprocessable_entity }
        format.xml { render xml: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1.xml
  # DELETE /products/1.json
  def destroy
    @product.destroy
  
    respond_to do |format|
      format.xml { head :no_content }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def product_params
    params.require(:product).permit(:sku, :price, :name, :description, :amount)
  end
end
