defmodule EmailServiceWeb.EmailController do
  use EmailServiceWeb, :controller

  alias EmailService.MailCtx
  # alias EmailService.MailCtx.Email

  action_fallback EmailServiceWeb.FallbackController

  def send_email(conn, params) do
    with {:ok, email} <- MailCtx.validate_params(params) do
      render(conn, "show.json", email: email)
    end
  end
end
