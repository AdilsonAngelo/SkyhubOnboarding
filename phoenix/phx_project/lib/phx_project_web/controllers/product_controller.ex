defmodule PhxProjectWeb.ProductController do
  use PhxProjectWeb, :controller

  alias PhxProject.ProductsCtx
  alias PhxProject.ProductsCtx.Product

  action_fallback PhxProjectWeb.FallbackController

  def index(conn, _params) do
    products = ProductsCtx.list_products()
    render(conn, "index.json", products: products)
  end

  def create(conn, product_params) do
    with {:ok, %Product{} = product} <- ProductsCtx.create_product(product_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.product_path(conn, :show, product))
      |> render("show.json", product: product)
    end
  end

  def show(conn, %{"id" => id}) do
    product = ProductsCtx.get_product!(id)
    render(conn, "show.json", product: product)
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    product = ProductsCtx.get_product!(id)

    with {:ok, %Product{} = product} <- ProductsCtx.update_product(product, product_params) do
      render(conn, "show.json", product: product)
    end
  end

  def update(conn, %{"id" => _id}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(PhxProjectWeb.ErrorView)
    |> render(:"422")
  end

  def delete(conn, %{"id" => id}) do
    product = ProductsCtx.get_product!(id)

    with {:ok, %Product{}} <- ProductsCtx.delete_product(product) do
      send_resp(conn, :no_content, "")
    end
  end
end