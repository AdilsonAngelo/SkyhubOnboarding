defmodule PhxProjectWeb.ProductControllerTest do
  use PhxProjectWeb.ConnCase

  alias PhxProject.ProductsCtx
  alias PhxProject.ProductsCtx.Product
  alias PhxProject.ProductsCtx.ProductReport
  alias PhxProject.Utils.RedisHelper
  alias PhxProject.Utils.ESHelper

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
      %{product: %{id: id}} = create_product(nil)

      product =
        Map.merge(@create_attrs, %{id: id})
        |> Map.new(fn {k, v} -> {Atom.to_string(k), v} end)

      conn = get(conn, Routes.product_path(conn, :index))
      assert json_response(conn, 200) == [product]
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

      assert %Product{
        id: id,
        sku: "AA-111",
        name: "foo",
        barcode: "00100100",
        description: nil,
        price: nil,
        amount: nil,
      } = ProductsCtx.get_product!(id)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.product_path(conn, :create), @invalid_attrs)

      assert %{
        "amount" => ["must be greater than or equal to 0"],
        "barcode" => ["has invalid format"],
        "description" => ["is invalid"],
        "name" => ["can't be blank"],
        "price" => ["must be greater than 0"],
        "sku" => ["has invalid format"]
      } == json_response(conn, 422)["errors"]
    end

    test "renders errors when sku or barcode already exists", %{conn: conn} do
      fixture(:product)
      conn = post(conn, Routes.product_path(conn, :create), @create_attrs)

      assert %{
        "barcode" => ["barcode already exists"],
        "sku" => ["sku already exists"]
      } == json_response(conn, 422)["errors"]
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

      assert %Product{
        id: id,
        sku: "A1B234",
        name: "Foo",
        barcode: "00200200200",
        description: "Bar",
        price: 456.7,
        amount: 43,
      } = ProductsCtx.get_product!(id)
    end

    test "renders errors when data is invalid", %{conn: conn, product: product} do
      conn = put(conn, Routes.product_path(conn, :update, product), product: @invalid_attrs)
      assert %{
        "amount" => ["must be greater than or equal to 0"],
        "barcode" => ["has invalid format"],
        "description" => ["is invalid"],
        "name" => ["can't be blank"],
        "price" => ["must be greater than 0"],
        "sku" => ["has invalid format"]
      } == json_response(conn, 422)["errors"]
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

  describe "redis" do
    test "cache on creation", %{conn: conn} do
      conn = post(conn, Routes.product_path(conn, :create), @create_attrs)
      product = json_response(conn, 201)

      assert map_to_product(@create_attrs, [{:id, product["id"]}]) == RedisHelper.get(product["id"], %Product{})
    end

    test "cache on show", %{conn: conn} do
      {:ok, product} = PhxProject.ProductsCtx.create_product(@create_attrs)

      assert :undefined == RedisHelper.get(product.id, %Product{})

      get(conn, Routes.product_path(conn, :show, product.id))

      assert map_to_product(@create_attrs, [{:id, product.id}]) == RedisHelper.get(product.id, %Product{})
    end

    test "cache on update", %{conn: conn} do
      {:ok, product} = PhxProject.ProductsCtx.create_product(@create_attrs)

      assert :undefined == RedisHelper.get(product.id, %Product{})

      conn = put(conn, Routes.product_path(conn, :update, product), product: @update_attrs)

      assert map_to_product(@update_attrs, [{:id, product.id}]) == RedisHelper.get(product.id, %Product{})
    end

    test "clear cache on delete", %{conn: conn} do
      conn = post(conn, Routes.product_path(conn, :create), @create_attrs)
      product = json_response(conn, 201)

      check_product = map_to_product(@create_attrs, [{:id, product["id"]}])

      assert check_product == RedisHelper.get(check_product.id, %Product{})

      conn = delete(conn, Routes.product_path(conn, :delete, check_product))
      assert response(conn, 204)

      assert :undefined == RedisHelper.get(check_product.id, %Product{})
    end
  end

  describe "elasticsearch log" do
    setup [:create_product]

    test "on GET /products", %{conn: conn} do
      conn = get(conn, Routes.product_path(conn, :index))
      {_, log} =
        conn
        |> ESHelper.conn_to_log()
        |> Map.pop(:created_at)
      assert log = ESHelper.get_log(conn, :products)
    end

    test "on GET /products/:id", %{conn: conn, product: product} do
      conn = get(conn, Routes.product_path(conn, :show, product.id))
      {_, log} =
        conn
        |> ESHelper.conn_to_log()
        |> Map.pop(:created_at)
      assert log = ESHelper.get_log(conn, :products)
    end

    test "on POST /products", %{conn: conn} do
      conn = post(conn, Routes.product_path(conn, :create), @create_attrs)
      {_, log} =
        conn
        |> ESHelper.conn_to_log()
        |> Map.pop(:created_at)
      assert log = ESHelper.get_log(conn, :products)
    end

    test "on PUT|PATCH /products/:id", %{conn: conn, product: product} do
      conn = put(conn, Routes.product_path(conn, :update, product), product: @update_attrs)
      {_, log} =
        conn
        |> ESHelper.conn_to_log()
        |> Map.pop(:created_at)
      assert log = ESHelper.get_log(conn, :products)
    end

    test "on DELETE /products/:id", %{conn: conn, product: product} do
      conn = delete(conn, Routes.product_path(conn, :delete, product))
      {_, log} =
        conn
        |> ESHelper.conn_to_log()
        |> Map.pop(:created_at)
      assert log = ESHelper.get_log(conn, :products)
    end
  end

  describe "reports:" do
    setup [:create_product]

    test "enqueue on GET /products/report", %{conn: conn} do
      conn = get(conn, Routes.product_path(conn, :report))
      assert %{
        "request_id" => id,
        "message" => "Queueing request"
      } = json_response(conn, 200)
    end
  end

  defp create_product(_) do
    product = fixture(:product)
    %{product: product}
  end

  defp map_to_product(map, other_items \\ []) do
    opts = Enum.map(map, fn {k, v} -> {k, v} end)
    opts = opts ++ other_items

    struct(Product, opts)
  end
end
