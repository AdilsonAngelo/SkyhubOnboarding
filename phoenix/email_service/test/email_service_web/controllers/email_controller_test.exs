defmodule EmailServiceWeb.EmailControllerTest do
  use EmailServiceWeb.ConnCase
  use Bamboo.Test

  alias EmailService.MailCtx
  alias EmailService.MailCtx.Email

  @create_attrs %{
    to: "test@test.com",
    from: "test@test.com.br",
    subject: "some subject",
    body: "some body",
    attachments: [%{filename: "test.csv", content: "testing,this,csv\n1,2,3"}]
  }
  @invalid_attrs %{attachments: nil, body: nil, from: nil, subject: nil, to: nil}

  describe "send_email" do
    test "sends email with valid data", %{conn: conn} do
      conn = post(conn, Routes.email_path(conn, :send_email), @create_attrs)

      assert response(conn, 204)

      assert_delivered_email create_email()
    end

    test "render errors and doesn't send email with invalid data", %{conn: conn} do
      conn = post(conn, Routes.email_path(conn, :send_email), @invalid_attrs)
      assert %{
        "to" => ["can't be blank"],
        "from" => ["can't be blank"],
        "subject" => ["can't be blank"],
        "attachments" => ["is invalid"],
      } == json_response(conn, 422)["errors"]

      assert_no_emails_delivered()
    end
  end

  defp create_email() do
    @create_attrs
    |> MailCtx.parse_params()
    |> MailCtx.create_email()
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end
end
