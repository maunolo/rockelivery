defmodule Rockelivery.Orders.Create do
  import Ecto.Query

  alias Rockelivery.{Error, Item, Order, Repo}
  alias Rockelivery.Items.ValidateAndMultiply, as: ValidateAndMultiplyItems

  def call(params) do
    with {:ok, params} <- fetch_items(params),
         {:ok, %Order{}} = result <- create_order(params) do
      result
    else
      {:error, _} = error -> error
    end
  end

  defp create_order(params) do
    params
    |> Order.changeset()
    |> Repo.insert()
    |> handle_insert()
  end

  defp handle_insert({:ok, %Order{}} = result), do: result
  defp handle_insert({:error, result}), do: {:error, Error.build(:bad_request, result)}

  defp fetch_items(%{items: items_params} = params) do
    item_ids = Enum.map(items_params, fn item -> item.id end)

    Repo.all(from item in Item, where: item.id in ^item_ids)
    |> ValidateAndMultiplyItems.call(item_ids, items_params)
    |> handle_items(params)
  end

  defp handle_items({:ok, items}, params), do: {:ok, %{params | items: items}}
  defp handle_items({:error, result}, _params), do: {:error, Error.build(:bad_request, result)}
end
