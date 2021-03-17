class ProductsController < ApplicationController
  before_action :set_product, except: [:index, :create]

  # GET /products
  def index
    @products = Product.order(created_at: :desc)
  
    render template: "products/index.html.erb"
  end

  # GET /products/1
  def show
    render template: "products/show.html.erb"
  end

  # GET /products/new
  def new
    @product = Product.new
    render template: "products/new.html.erb"
  end

  # GET /products/1/edit
  def edit
    render template: "products/edit.html.erb"
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
