defmodule EmailService.MailCtx.Email do
  use Ecto.Schema
  import Ecto.Changeset

  @required_attrs [:to, :from, :subject]
  @other_attrs [:body, :attachments]
  @all_attrs @required_attrs ++ @other_attrs

  schema "emails" do
    field :to, :string
    field :from, :string
    field :subject, :string
    field :body, :string
    field :attachments, :string
  end

  @doc false
  def changeset(email, attrs) do
    email
    |> cast(attrs, @all_attrs)
    |> validate_required(@required_attrs)
  end
end
