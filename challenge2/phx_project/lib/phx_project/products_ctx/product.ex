defmodule PhxProject.ProductsCtx.Product do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "products" do
    field :amount, :integer
    field :description, :string
    field :name, :string
    field :price, :float
    field :sku, :string

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:sku, :price, :name, :description, :amount])
    |> validate_required([:sku, :price, :name, :description, :amount])
    |> validate_number(:price, greater_than: 0)
  end
end
