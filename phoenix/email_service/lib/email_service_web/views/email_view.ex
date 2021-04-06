defmodule EmailServiceWeb.EmailView do
  use EmailServiceWeb, :view
  alias EmailServiceWeb.EmailView

  def render("index.json", %{emails: emails}) do
    render_many(emails, EmailView, "email.json")
  end

  def render("show.json", %{email: email}) do
    render_one(email, EmailView, "email.json")
  end

  def render("email.json", %{email: email}) do
    %{
      to: email.to,
      from: email.from,
      subject: email.subject,
      body: email.body,
      attachments: email.attachments
    }
  end
end
