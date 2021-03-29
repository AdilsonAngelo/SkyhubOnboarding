defmodule PhxProjectWeb.ProductView do
  use PhxProjectWeb, :view
  alias PhxProjectWeb.ProductView

  def render("index.json", %{products: products}) do
    render_many(products, ProductView, "product.json")
  end

  def render("show.json", %{product: product}) do
    render_one(product, ProductView, "product.json")
  end

  def render("product.json", %{product: product}) do
    %{id: product.id,
      sku: product.sku,
      price: product.price,
      name: product.name,
      description: product.description,
      amount: product.amount,
      barcode: product.barcode}
  end
end
