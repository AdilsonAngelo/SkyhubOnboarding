defmodule PhxProject.ProductsCtxTest do
  use PhxProject.DataCase

  alias PhxProject.ProductsCtx
  alias PhxProject.ProductsCtx.Product
  alias PhxProject.ProductsCtx.ProductReport

  describe "products" do
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
      assert "has invalid format" in errors_on(changeset).barcode
      assert "has invalid format" in errors_on(changeset).sku
      assert "must be greater than or equal to 0" in errors_on(changeset).amount
      assert "must be greater than 0" in errors_on(changeset).price
      assert "can't be blank" in errors_on(changeset).name
      assert "is invalid" in errors_on(changeset).description
    end

    test "create_product/1 returns error for existing sku and barcode" do
      product_fixture()

      assert {:error, %Ecto.Changeset{} = changeset} = ProductsCtx.create_product(@valid_attrs)
      assert "barcode already exists" in errors_on(changeset).barcode
      assert "sku already exists" in errors_on(changeset).sku
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

  describe "product report" do
    def seed_fixture() do
      [
        %{sku: "AA-111", name: "foo", barcode: "00100100", description: nil, price: 120.5, amount: 0},
        %{sku: "AA-112", name: "Foo", barcode: "00200200", description: "Bar", price: nil, amount: nil},
        %{sku: "AA-113", name: "Bar", barcode: "00300300", description: "Foo", price: 1.5, amount: 2}
      ]
      |> Enum.map(fn p ->
        {:ok, product} = ProductsCtx.create_product(p)
        product
      end)
    end

    setup do
      [products: seed_fixture()]
    end

    test "generate_report/1 stores all products correctly", %{products: products} do
      {:ok, report_path} = ProductReport.generate_report()
      report_products = ProductReport.read_report(report_path)

      assert Enum.zip(products, report_products)
        |> Enum.map(fn {prod1, prod2} ->
          changeset = Product.changeset(prod1, Map.from_struct(prod2))
          changeset.changes == %{}
        end)
        |> Enum.all?()
    end
  end

end
