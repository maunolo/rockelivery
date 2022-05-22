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
      # "01001000"
      zip_code: "12345678"
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

  def cep_info_factory do
    %{
      "bairro" => "Sé",
      "cep" => "01001-000",
      "complemento" => "lado ímpar",
      "ddd" => "11",
      "gia" => "1004",
      "ibge" => "3550308",
      "localidade" => "São Paulo",
      "logradouro" => "Praça da Sé",
      "siafi" => "7107",
      "uf" => "SP"
    }
  end
end
