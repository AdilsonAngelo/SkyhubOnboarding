defmodule EmailService.MailCtx.Email do
  use Ecto.Schema
  import Ecto.Changeset

  alias EmailService.MailCtx.Attachment

  @required_attrs [:to, :from, :subject]
  @other_attrs [:body]
  @all_fields @required_attrs ++ @other_attrs

  @primary_key false
  schema "emails" do
    field :to, :string
    field :from, :string
    field :subject, :string
    field :body, :string
    embeds_many :attachments, Attachment
  end

  @doc false
  def changeset(email, attrs) do
    email
    |> cast(attrs, @all_fields)
    |> cast_embed(:attachments, with: &Attachment.changeset/2)
    |> validate_required(@required_attrs)
  end

end
