defmodule Rockelivery.User do
  use Ecto.Schema

  import Ecto.Changeset

  alias Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  @cast_params [:age, :address, :document_id, :email, :password, :name, :zip_code]
  @required_params @cast_params -- [:age]
  @update_params @required_params -- [:password]

  @derive {Jason.Encoder, only: [:id, :age, :document_id, :address, :email]}

  schema "users" do
    field :address, :string
    field :age, :integer
    field :document_id, :string
    field :email, :string
    field :password, :string, virtual: true
    field :encrypted_password, :string
    field :name, :string
    field :zip_code, :string

    timestamps()
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @cast_params)
    |> validate_required_params(state(struct))
    |> validate_length(:password, min: 6)
    |> validate_length(:zip_code, is: 8)
    |> validate_length(:document_id, min: 10, max: 14)
    |> validate_number(:age, greater_than_or_equal_to: 18)
    |> validate_format(:email, ~r/@/)
    |> validate_person_age()
    |> unique_constraint([:email])
    |> unique_constraint([:document_id])
    |> put_encrypted_password()
  end

  defp validate_required_params(changeset, state) do
    params = if state == :built, do: @required_params, else: @update_params
    validate_required(changeset, params)
  end

  defp put_encrypted_password(
         %Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, encrypted_password: Pbkdf2.add_hash(password)[:password_hash])
  end

  defp put_encrypted_password(changeset), do: changeset

  defp validate_person_age(changeset) do
    if is_person?(changeset) && !present?(changeset, :age) do
      add_error(changeset, :age, "must be present when document id is from a person",
        validation: :person_age
      )
    else
      changeset
    end
  end

  defp is_person?(changeset) do
    document_id = get_field(changeset, :document_id)

    document_length = String.length(document_id)

    10 <= document_length and document_length <= 11
  end

  defp present?(changeset, field) do
    value = get_field(changeset, field)
    value && value != ""
  end

  defp state(%__MODULE__{} = struct), do: Ecto.get_meta(struct, :state)
  defp state(%Changeset{}), do: :built
end
