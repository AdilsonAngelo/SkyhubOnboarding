defmodule PhxProject.ProductsCtx.Product do
  use Ecto.Schema
  import Ecto.Changeset

  alias PhxProject.ProductsCtx

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
    |> validate_number(:amount, greater_than_or_equal_to: 0)
    |> validate_format(:sku, ~r/^[A-Z\d]{6}$/)
    |> validate_sku_unique
  end

  def validate_sku_unique(changeset) do
    case changeset.valid? do
      true ->
        changeset
        |> validate_change(:sku, fn :sku, val ->
          if ProductsCtx.sku_exists?(val) do
            [sku: "sku already exists"]
          else
            []
          end
        end)

      _ ->
        changeset
    end
  end
end
