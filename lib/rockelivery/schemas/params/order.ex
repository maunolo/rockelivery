defmodule Rockelivery.Params.Order do
  use Ecto.Schema

  import Ecto.Changeset

  alias Ecto.Changeset
  alias Ecto.UUID
  alias Rockelivery.Error

  @primary_key false

  @required_order_params [:user_id, :address, :comments, :payment_method]
  @required_item_params [:id, :quantity]

  schema "orders params" do
    field :user_id, :string
    field :comments, :string
    field :payment_method, :string
    field :address, :string

    embeds_many :items, ItemParams do
      field :quantity, :integer
    end
  end

  def validate(params) do
    case changeset(params) do
      %Changeset{valid?: true} -> {:ok, params}
      %Changeset{valid?: false} = result -> {:error, Error.build(:unprocessable_entity, result)}
    end
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @required_order_params)
    |> cast_embed(:items, with: &item_changeset/2)
    |> validate_required(@required_order_params ++ [:items])
    |> validate_uuid(:user_id)
    |> validate_items()
  end

  defp validate_items(changeset) do
    items = get_field(changeset, :items)

    if length(items) > 1 do
      changeset
    else
      add_error(changeset, :items, "can't be blank", validation: :items_length)
    end
  end

  defp item_changeset(struct, params) do
    struct
    |> cast(params, @required_item_params)
    |> validate_required(@required_item_params)
    |> validate_uuid(:id)
    |> validate_number(:quantity, greater_than: 0)
  end

  defp validate_uuid(changeset, field) do
    id = get_field(changeset, field)

    with false <- is_nil(id),
         {:ok, _uuid} <- UUID.cast(id) do
      changeset
    else
      true ->
        changeset

      :error ->
        add_error(changeset, field, "'%{id}' must be a valid uuid", validation: :uuid, id: id)
    end
  end
end
