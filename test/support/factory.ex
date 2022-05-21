defmodule Rockelivery.Factory do
  use ExMachina.Ecto, repo: Rockelivery.Repo

  alias Rockelivery.User

  def user_params_factory do
    %{
      address: "Street Test, 69",
      age: 21,
      document_id: "12345678900",
      email: "test@test.com",
      password: "123456",
      name: "Test",
      zip_code: "10000100"
    }
  end

  def user_factory do
    %User{
      address: "Street Test, 69",
      age: 21,
      document_id: "12345678900",
      email: "test@test.com",
      password: "123456",
      name: "Test",
      zip_code: "10000100"
    }
  end
end
