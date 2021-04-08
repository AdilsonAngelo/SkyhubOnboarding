defmodule EmailService.MailCtx do
  @moduledoc """
  The MailCtx context.
  """
  import Bamboo.Email

  alias EmailService.MailCtx.Email
  alias EmailService.MailCtx.Attachment

  def parse_params(params \\ %{}) do
    changeset = Email.changeset(%Email{}, params)

    case changeset.valid? do
      true ->
        Ecto.Changeset.apply_changes(changeset)
      false ->
        {:error, changeset}
    end
  end

  def create_email(%Email{} = email) do
    new =
      new_email()
      |> to(email.to)
      |> from(email.from)
      |> subject(email.subject)
      |> text_body(email.body)

    email.attachments
    |> Enum.map(&convert_attachment/1)
    |> Enum.reduce(new, fn attachment, acc ->
      put_attachment(acc, attachment)
    end)
  end

  def convert_attachment(%Attachment{} = attachment) do
    %Bamboo.Attachment{
      filename: attachment.filename,
      data: attachment.content
    }
  end
end
