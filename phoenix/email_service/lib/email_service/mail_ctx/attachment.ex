defmodule EmailService.MailCtx.Attachment do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:filename, :content]}
  embedded_schema do
    field :content, :binary
    field :filename, :string
  end

  @doc false
  def changeset(attachment, attrs) do
    attachment
    |> cast(attrs, [:filename, :content])
    |> validate_required([:filename, :content])
  end
end
