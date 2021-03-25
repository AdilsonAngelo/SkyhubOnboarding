defmodule PhxProject.ProductsCtxTest do
  use PhxProject.DataCase

  alias PhxProject.ProductsCtx

  describe "products" do
    alias PhxProject.ProductsCtx.Product
    @valid_attrs %{
      sku: "AA-111",
      name: "foo",
      barcode: "00100100",
      description: nil,
      price: 120.5,
      amount: nil
    }
    @update_attrs %{
      sku: "A1B234",
      name: "Foo",
      barcode: "00200200200",
      description: "Bar",
      price: 456.7,
      amount: 43,
    }
    @invalid_attrs %{
      sku: "Invalid Format",
      name: nil,
      barcode: "Not Numbers",
      description: 123,
      price: 0,
      amount: -1,
    }

    def product_fixture(attrs \\ %{}) do
      {:ok, product} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ProductsCtx.create_product()

      product
    end

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert ProductsCtx.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert ProductsCtx.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      assert {:ok, %Product{} = product} = ProductsCtx.create_product(@valid_attrs)
      assert product.sku == "AA-111"
      assert product.name == "foo"
      assert product.barcode == "00100100"
      assert product.description == nil
      assert product.price == 120.5
      assert product.amount == nil
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{} = changeset} = ProductsCtx.create_product(@invalid_attrs)
      assert changeset.errors == [barcode: {"has invalid format", [validation: :format]},
                                  sku: {"has invalid format", [validation: :format]},
                                  amount: {"must be greater than or equal to %{number}", [validation: :number, number: 0]},
                                  price: {"must be greater than %{number}", [validation: :number, number: 0]},
                                  name: {"can't be blank", [validation: :required]},
                                  description: {"is invalid", [type: :string, validation: :cast]}]
    end

    test "create_product/1 returns error for existing sku and barcode" do
      product_fixture()

      assert {:error, %Ecto.Changeset{} = changeset} = ProductsCtx.create_product(@valid_attrs)
      assert changeset.errors == [barcode: {"barcode already exists", []}, sku: {"sku already exists", []}]
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      assert {:ok, %Product{} = product} = ProductsCtx.update_product(product, @update_attrs)
      assert product.sku == "A1B234"
      assert product.name == "Foo"
      assert product.barcode == "00200200200"
      assert product.description == "Bar"
      assert product.price == 456.7
      assert product.amount == 43
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = ProductsCtx.update_product(product, @invalid_attrs)
      assert product == ProductsCtx.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = ProductsCtx.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> ProductsCtx.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = ProductsCtx.change_product(product)
    end
  end
end
