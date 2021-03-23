defmodule PhxProjectWeb.ProductController do
  use PhxProjectWeb, :controller

  alias PhxProject.ProductsCtx
  alias PhxProject.ProductsCtx.Product
  alias PhxProject.ProductsCtx.ProductData

  action_fallback PhxProjectWeb.FallbackController

  def index(conn, _params) do
    products = ProductsCtx.list_products()
    conn
    |> render("index.json", products: products)
  end

  def create(conn, product_params) do
    with {:ok, %Product{} = product} <- ProductData.create(product_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.product_path(conn, :show, product))
      |> render("show.json", product: product)
    end
  end

  def show(conn, %{"id" => id}) do
    conn
    |> render("show.json", product: ProductData.get(id))
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    with {:ok, %Product{} = product} <- ProductData.update(id, product_params) do
      conn
      |> render("show.json", product: product)
    end
  end

  def update(conn, %{"id" => _id}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(PhxProjectWeb.ErrorView)
    |> render(:"422")
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %Product{}} <- ProductData.delete(id) do
      conn
      |> send_resp(:no_content, "")
    end
  end
end
