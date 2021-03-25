defmodule PhxProjectWeb.ProductControllerTest do
  use PhxProjectWeb.ConnCase

  alias PhxProject.ProductsCtx
  alias PhxProject.ProductsCtx.Product

  @create_attrs %{
    sku: "AA-111",
    name: "foo",
    barcode: "00100100",
    description: nil,
    price: nil,
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

  def fixture(:product) do
    {:ok, product} = ProductsCtx.create_product(@create_attrs)
    product
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all products", %{conn: conn} do
      conn = get(conn, Routes.product_path(conn, :index))
      assert json_response(conn, 200) == []
    end
  end

  describe "create product" do
    test "renders product when data is valid", %{conn: conn} do
      conn = post(conn, Routes.product_path(conn, :create), @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, Routes.product_path(conn, :show, id))

      assert %{
               "id" => id,
               "sku" => "AA-111",
               "name" => "foo",
               "barcode" => "00100100",
               "description" => nil,
               "price" => nil,
               "amount" => nil,
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.product_path(conn, :create), @invalid_attrs)

      assert %{"errors" => %{
          "amount" => ["must be greater than or equal to 0"],
          "barcode" => ["has invalid format"],
          "description" => ["is invalid"],
          "name" => ["can't be blank"],
          "price" => ["must be greater than 0"],
          "sku" => ["has invalid format"]
        }
      } == json_response(conn, 422)
    end

    test "renders errors when sku or barcode already exists", %{conn: conn} do
      fixture(:product)
      conn = post(conn, Routes.product_path(conn, :create), @create_attrs)

      assert %{"errors" => %{
          "barcode" => ["barcode already exists"],
          "sku" => ["sku already exists"]
        }
      } == json_response(conn, 422)
    end
  end

  describe "update product" do
    setup [:create_product]

    test "renders product when data is valid", %{conn: conn, product: %Product{id: id} = product} do
      conn = put(conn, Routes.product_path(conn, :update, product), product: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, Routes.product_path(conn, :show, id))

      assert %{
               "id" => id,
               "sku" => "A1B234",
               "name" => "Foo",
               "description" => "Bar",
               "price" => 456.7,
               "amount" => 43,
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, product: product} do
      conn = put(conn, Routes.product_path(conn, :update, product), product: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete product" do
    setup [:create_product]

    test "deletes chosen product", %{conn: conn, product: product} do
      conn = delete(conn, Routes.product_path(conn, :delete, product))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.product_path(conn, :show, product))
      end
    end
  end

  defp create_product(_) do
    product = fixture(:product)
    %{product: product}
  end
end
