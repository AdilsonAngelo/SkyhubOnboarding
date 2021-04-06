defmodule EmailServiceWeb.EmailControllerTest do
  use EmailServiceWeb.ConnCase

  alias EmailService.MailCtx
  alias EmailService.MailCtx.Email

  @create_attrs %{
    attachments: "some attachments",
    body: "some body",
    from: "some from",
    subject: "some subject",
    to: "some to"
  }
  @update_attrs %{
    attachments: "some updated attachments",
    body: "some updated body",
    from: "some updated from",
    subject: "some updated subject",
    to: "some updated to"
  }
  @invalid_attrs %{attachments: nil, body: nil, from: nil, subject: nil, to: nil}

  def fixture(:email) do
    {:ok, email} = MailCtx.create_email(@create_attrs)
    email
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all emails", %{conn: conn} do
      conn = get(conn, Routes.email_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create email" do
    test "renders email when data is valid", %{conn: conn} do
      conn = post(conn, Routes.email_path(conn, :create), email: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.email_path(conn, :show, id))

      assert %{
               "id" => id,
               "attachments" => "some attachments",
               "body" => "some body",
               "from" => "some from",
               "subject" => "some subject",
               "to" => "some to"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.email_path(conn, :create), email: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update email" do
    setup [:create_email]

    test "renders email when data is valid", %{conn: conn, email: %Email{id: id} = email} do
      conn = put(conn, Routes.email_path(conn, :update, email), email: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.email_path(conn, :show, id))

      assert %{
               "id" => id,
               "attachments" => "some updated attachments",
               "body" => "some updated body",
               "from" => "some updated from",
               "subject" => "some updated subject",
               "to" => "some updated to"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, email: email} do
      conn = put(conn, Routes.email_path(conn, :update, email), email: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete email" do
    setup [:create_email]

    test "deletes chosen email", %{conn: conn, email: email} do
      conn = delete(conn, Routes.email_path(conn, :delete, email))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.email_path(conn, :show, email))
      end
    end
  end

  defp create_email(_) do
    email = fixture(:email)
    %{email: email}
  end
end
