defmodule PhxProject.ProductsCtx.Product do
  use Ecto.Schema
  import Ecto.Changeset

  @required_attrs [:sku, :name, :barcode]
  @other_attrs [:description, :price, :amount]
  @all_attrs @required_attrs ++ @other_attrs

  alias PhxProject.ProductsCtx
  @derive {Poison.Encoder, only: [:id | @all_attrs]}
  @primary_key {:id, :binary_id, autogenerate: true}

  schema "products" do
    field :amount, :integer
    field :description, :string
    field :name, :string
    field :price, :float
    field :sku, :string
    field :barcode, :string

    timestamps(usec: false)
  end

  def changeset(product, attrs) do
    product
    |> cast(attrs, @all_attrs)
    |> validate_required(@required_attrs)
    |> validate_number(:price, greater_than: 0)
    |> validate_number(:amount, greater_than_or_equal_to: 0)
    |> validate_format(:sku, ~r/^[A-Z\d-]{6}$/i)
    |> validate_format(:barcode, ~r/^\d{8,13}$/)
    |> validate_unique(:sku)
    |> validate_unique(:barcode)
  end

  def validate_unique(changeset, attr) do
    validate_change(changeset, attr, fn attr, val ->
      if ProductsCtx.attribute_value_exists?(attr, val) do
        [{attr, "#{attr} already exists"}]
      else
        []
      end
    end)
  end

  def get_attrs(), do: @all_attrs
end
