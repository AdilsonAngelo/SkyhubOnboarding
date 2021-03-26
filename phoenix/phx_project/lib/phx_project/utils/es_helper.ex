defmodule PhxProject.Utils.ESHelper do

  def to_es_before_send(%Plug.Conn{} = conn, index) do
    id = Ecto.UUID.generate
    Tirexs.HTTP.post!("/#{index}/_create/#{id}", conn_to_log(conn))
    conn |> Plug.Conn.assign(:es_id, id)
  end

  def conn_to_log(%Plug.Conn{} = conn) do
    %{
      url: conn.request_path,
      request_body: Poison.encode!(conn.body_params),
      request_method: conn.method,
      response_body: IO.iodata_to_binary(conn.resp_body),
      response_status: conn.status,
      created_at: NaiveDateTime.utc_now |> NaiveDateTime.to_iso8601
    }
  end

  def get_log(%Plug.Conn{} = conn, index) do
    with {:ok, _, hit} <- get_log_by_id(conn.assigns[:es_id], index) do
      hit[:_source]
    end
  end

  def get_log_by_id(id, index) do
    Tirexs.HTTP.get("/#{index}/_doc/#{id}")
  end
end
