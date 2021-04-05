defmodule PhxProjectWeb.Plugs.ProductsPlug do
  import Plug.Conn

  alias PhxProject.Utils.ESHelper

  @es_index :products

  def init(_params) do
  end

  def call(%Plug.Conn{} = conn, _params) do
    conn
    |> register_before_send(&products_before_send/1)
  end

  defp products_before_send(conn), do: ESHelper.to_es_before_send(conn, @es_index)
end
