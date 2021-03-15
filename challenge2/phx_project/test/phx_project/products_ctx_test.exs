defmodule PhxProject.ProductsCtxTest do
  use PhxProject.DataCase

  alias PhxProject.ProductsCtx

  describe "products" do
    alias PhxProject.ProductsCtx.Product

    @valid_attrs %{amount: 42, description: "some description", name: "some name", price: 120.5, sku: "some sku"}
    @update_attrs %{amount: 43, description: "some updated description", name: "some updated name", price: 456.7, sku: "some updated sku"}
    @invalid_attrs %{amount: nil, description: nil, name: nil, price: nil, sku: nil}

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
      assert product.amount == 42
      assert product.description == "some description"
      assert product.name == "some name"
      assert product.price == 120.5
      assert product.sku == "some sku"
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ProductsCtx.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      assert {:ok, %Product{} = product} = ProductsCtx.update_product(product, @update_attrs)
      assert product.amount == 43
      assert product.description == "some updated description"
      assert product.name == "some updated name"
      assert product.price == 456.7
      assert product.sku == "some updated sku"
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