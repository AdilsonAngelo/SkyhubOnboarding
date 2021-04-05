defmodule PhxProject.ProductsCtx.ProductData do
  alias PhxProject.ProductsCtx
  alias PhxProject.ProductsCtx.Product
  alias PhxProject.Utils.RedisHelper

  def list(), do: ProductsCtx.list_products()

  def get(id) do
    with :undefined <- RedisHelper.get(id, %Product{}) do
      ProductsCtx.get_product!(id)
      |> RedisHelper.set
    end
  end

  def create(product_params) do
    with {:ok, %Product{} = product} <- ProductsCtx.create_product(product_params) do
      RedisHelper.set(product)
      {:ok, product}
    end
  end

  def update(id, product_params) do
    product = ProductsCtx.get_product!(id)

    with {:ok, %Product{} = product} <- ProductsCtx.update_product(product, product_params) do
      RedisHelper.set(product)
      {:ok, product}
    end
  end

  @spec delete(String.t) :: any
  def delete(id) do
    product = ProductsCtx.get_product!(id)
    RedisHelper.delete(id)
    ProductsCtx.delete_product(product)
  end
end
