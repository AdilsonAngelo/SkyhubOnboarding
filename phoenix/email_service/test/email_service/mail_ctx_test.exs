defmodule EmailService.MailCtxTest do
  use ExUnit.Case
  use Bamboo.Test

  alias Bamboo.SentEmail
  alias EmailService.MailCtx
  alias EmailService.MailCtx.Mailer

  describe "emails" do
    alias EmailService.MailCtx.Email
    alias EmailService.MailCtx.Attachment

    @valid_attrs %{
      to: "test@test.com",
      from: "test@test.com.br",
      subject: "some subject",
      body: "some body",
      attachments: [%{filename: "test.csv", content: "testing,this,csv\n1,2,3"}]
    }
    @invalid_attrs %{
      body: nil,
      from: nil,
      subject: nil,
      to: nil
    }

    test "validate_params/1 with valid data returns email" do
      email = MailCtx.parse_params(@valid_attrs)
      assert @valid_attrs.to == email.to
      assert @valid_attrs.from == email.from
      assert @valid_attrs.subject == email.subject
      assert @valid_attrs.body == email.body
      assert Enum.map(@valid_attrs.attachments, &struct!(%Attachment{}, &1)) == email.attachments
    end

    test "validate_params/1 with invalid data returns error" do
      assert {:error, changeset} = MailCtx.parse_params(@invalid_attrs)
      assert [
        to: {"can't be blank", [validation: :required]},
        from: {"can't be blank", [validation: :required]},
        subject: {"can't be blank", [validation: :required]}
      ] == changeset.errors
    end

    test "create_email/1 returns Bamboo.Email" do
      email =
        @valid_attrs
        |> MailCtx.parse_params()
        |> MailCtx.create_email()

      assert %Bamboo.Email{} = email

      assert @valid_attrs.to == email.to
      assert @valid_attrs.from == email.from
      assert @valid_attrs.subject == email.subject
      assert @valid_attrs.body == email.text_body
      assert @valid_attrs.attachments
        |> Enum.map(&struct!(%Attachment{}, &1))
        |> Enum.map(&MailCtx.convert_attachment/1) == email.attachments
    end

    test "Mailer.deliver_now/1 delivers the email" do
      email =
        @valid_attrs
        |> MailCtx.parse_params()
        |> MailCtx.create_email()
        |> Mailer.deliver_now()

      assert_delivered_email email
    end
  end
end
