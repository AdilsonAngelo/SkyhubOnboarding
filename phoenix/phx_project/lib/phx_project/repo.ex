defmodule PhxProject.Repo do
  use Ecto.Repo,
    otp_app: :phx_project,
    adapter: Mongo.Ecto
end
