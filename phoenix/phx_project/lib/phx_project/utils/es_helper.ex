defmodule PhxProject.Utils.ESHelper do
  require Logger

  def to_es_before_send(%Plug.Conn{} = conn, index) do
    Tirexs.HTTP.post!("/#{index}/_create/#{Ecto.UUID.generate}", conn_to_log(conn))
    conn
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
end
