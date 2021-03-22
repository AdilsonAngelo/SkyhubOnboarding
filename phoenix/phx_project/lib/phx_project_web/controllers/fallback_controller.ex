defmodule PhxProjectWeb.FallbackController do
  alias PhxProject.Utils.ESHelper

  @es_index :errors
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use PhxProjectWeb, :controller

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(PhxProjectWeb.ChangesetView)
    |> register_before_send(&error_before_send/1)
    |> render("error.json", changeset: changeset)
  end

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(PhxProjectWeb.ErrorView)
    |> register_before_send(&error_before_send/1)
    |> render(:"404")
  end

  def error_before_send(conn), do: ESHelper.to_es_before_send(conn, @es_index)
end
