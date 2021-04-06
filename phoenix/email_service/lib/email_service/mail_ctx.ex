defmodule EmailService.MailCtx do
  @moduledoc """
  The MailCtx context.
  """

  alias EmailService.MailCtx.Email

  def validate_params(params \\ %{}) do
    changeset = Email.changeset(%Email{}, params)

    case changeset.valid? do
      :true ->
        {:ok, Ecto.Changeset.apply_changes(changeset)}
      :false ->
        {:error, changeset}
    end
  end
end
