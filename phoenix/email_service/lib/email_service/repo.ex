defmodule EmailService.Repo do
  use Ecto.Repo,
    otp_app: :email_service,
    adapter: Ecto.Adapters.Postgres
end
