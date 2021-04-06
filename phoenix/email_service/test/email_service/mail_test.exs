defmodule EmailService.MailTest do
  use EmailService.DataCase

  alias EmailService.Mail

  describe "emails" do
    alias EmailService.Mail.Email

    @valid_attrs %{attachments: "some attachments", body: "some body", subject: "some subject", to_address: "some to_address"}
    @update_attrs %{attachments: "some updated attachments", body: "some updated body", subject: "some updated subject", to_address: "some updated to_address"}
    @invalid_attrs %{attachments: nil, body: nil, subject: nil, to_address: nil}

    def email_fixture(attrs \\ %{}) do
      {:ok, email} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Mail.create_email()

      email
    end

    test "list_emails/0 returns all emails" do
      email = email_fixture()
      assert Mail.list_emails() == [email]
    end

    test "get_email!/1 returns the email with given id" do
      email = email_fixture()
      assert Mail.get_email!(email.id) == email
    end

    test "create_email/1 with valid data creates a email" do
      assert {:ok, %Email{} = email} = Mail.create_email(@valid_attrs)
      assert email.attachments == "some attachments"
      assert email.body == "some body"
      assert email.subject == "some subject"
      assert email.to_address == "some to_address"
    end

    test "create_email/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Mail.create_email(@invalid_attrs)
    end

    test "update_email/2 with valid data updates the email" do
      email = email_fixture()
      assert {:ok, %Email{} = email} = Mail.update_email(email, @update_attrs)
      assert email.attachments == "some updated attachments"
      assert email.body == "some updated body"
      assert email.subject == "some updated subject"
      assert email.to_address == "some updated to_address"
    end

    test "update_email/2 with invalid data returns error changeset" do
      email = email_fixture()
      assert {:error, %Ecto.Changeset{}} = Mail.update_email(email, @invalid_attrs)
      assert email == Mail.get_email!(email.id)
    end

    test "delete_email/1 deletes the email" do
      email = email_fixture()
      assert {:ok, %Email{}} = Mail.delete_email(email)
      assert_raise Ecto.NoResultsError, fn -> Mail.get_email!(email.id) end
    end

    test "change_email/1 returns a email changeset" do
      email = email_fixture()
      assert %Ecto.Changeset{} = Mail.change_email(email)
    end
  end
end
