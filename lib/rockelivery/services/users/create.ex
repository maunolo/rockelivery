defmodule Rockelivery.Users.Create do
  alias Rockelivery.{Error, Repo, User}

  def call(params) do
    zip_code = Map.get(params, :zip_code)
    changeset = User.changeset(params)

    with {:ok, %User{}} <- User.build(changeset),
         {:ok, _zip_code_info} <- via_cep_client().get_cep_info(zip_code),
         {:ok, %User{}} = result <- Repo.insert(changeset) do
      result
    else
      {:error, %Error{}} = error -> error
      {:error, result} -> {:error, Error.build(:unprocessable_entity, result)}
    end
  end

  defp via_cep_client do
    :rockelivery
    |> Application.fetch_env!(__MODULE__)
    |> Keyword.get(:via_cep_client)
  end
end
