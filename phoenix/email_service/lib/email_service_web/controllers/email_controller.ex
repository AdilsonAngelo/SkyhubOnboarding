defmodule EmailServiceWeb.EmailController do
  use EmailServiceWeb, :controller

  alias EmailService.MailCtx
  alias EmailService.MailCtx.Email
  alias EmailService.MailCtx.Mailer

  action_fallback EmailServiceWeb.FallbackController

  def send_email(conn, params) do
    with %Email{} = email <- MailCtx.parse_params(params) do
      email
      |> MailCtx.create_email()
      |> Mailer.deliver_now()

      send_resp(conn, :no_content, "")
    end
  end
end
