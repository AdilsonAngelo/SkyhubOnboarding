defmodule EmailService.MailCtxTest do
  use EmailService.DataCase

  alias EmailService.MailCtx

  describe "emails" do
    alias EmailService.MailCtx.Email

    @valid_attrs %{attachments: "some attachments", body: "some body", from: "some from", subject: "some subject", to: "some to"}
    @update_attrs %{attachments: "some updated attachments", body: "some updated body", from: "some updated from", subject: "some updated subject", to: "some updated to"}
    @invalid_attrs %{attachments: nil, body: nil, from: nil, subject: nil, to: nil}

    def email_fixture(attrs \\ %{}) do
      {:ok, email} =
        attrs
        |> Enum.into(@valid_attrs)
        |> MailCtx.create_email()

      email
    end

    test "list_emails/0 returns all emails" do
      email = email_fixture()
      assert MailCtx.list_emails() == [email]
    end

    test "get_email!/1 returns the email with given id" do
      email = email_fixture()
      assert MailCtx.get_email!(email.id) == email
    end

    test "create_email/1 with valid data creates a email" do
      assert {:ok, %Email{} = email} = MailCtx.create_email(@valid_attrs)
      assert email.attachments == "some attachments"
      assert email.body == "some body"
      assert email.from == "some from"
      assert email.subject == "some subject"
      assert email.to == "some to"
    end

    test "create_email/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = MailCtx.create_email(@invalid_attrs)
    end

    test "update_email/2 with valid data updates the email" do
      email = email_fixture()
      assert {:ok, %Email{} = email} = MailCtx.update_email(email, @update_attrs)
      assert email.attachments == "some updated attachments"
      assert email.body == "some updated body"
      assert email.from == "some updated from"
      assert email.subject == "some updated subject"
      assert email.to == "some updated to"
    end

    test "update_email/2 with invalid data returns error changeset" do
      email = email_fixture()
      assert {:error, %Ecto.Changeset{}} = MailCtx.update_email(email, @invalid_attrs)
      assert email == MailCtx.get_email!(email.id)
    end

    test "delete_email/1 deletes the email" do
      email = email_fixture()
      assert {:ok, %Email{}} = MailCtx.delete_email(email)
      assert_raise Ecto.NoResultsError, fn -> MailCtx.get_email!(email.id) end
    end

    test "change_email/1 returns a email changeset" do
      email = email_fixture()
      assert %Ecto.Changeset{} = MailCtx.change_email(email)
    end
  end
end
