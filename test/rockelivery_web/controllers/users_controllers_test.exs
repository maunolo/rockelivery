defmodule RockeliveryWeb.UsersControllerTest do
  use RockeliveryWeb.ConnCase, async: true

  import Mox
  import Rockelivery.Factory

  alias Rockelivery.User
  alias Rockelivery.Utils.Map, as: MapUtil
  alias Rockelivery.ViaCep.ClientMock

  describe "create/2" do
    test "when all params are valid, creates the user", %{conn: conn} do
      params = MapUtil.stringify_keys(build(:user_params))

      expect(ClientMock, :get_cep_info, fn _cep -> {:ok, build(:cep_info)} end)

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:created)

      assert %{
               "message" => "User created!",
               "user" => %{
                 "address" => "Street Test, 69",
                 "age" => 21,
                 "document_id" => "12345678900",
                 "email" => "test@test.com",
                 "id" => _id
               }
             } = response
    end

    test "when there is an error, returns the error", %{conn: conn} do
      params = MapUtil.stringify_keys(build(:user_params, %{password: "123", age: 15}))

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:unprocessable_entity)

      expected_response = %{
        "message" => %{
          "age" => ["must be greater than or equal to 18"],
          "password" => ["should be at least 6 character(s)"]
        }
      }

      assert response == expected_response
    end
  end

  describe "delete/2" do
    test "when there is a user with the given id, deletes the user", %{conn: conn} do
      %User{id: id} = insert(:user)

      response =
        conn
        |> delete(Routes.users_path(conn, :delete, id))
        |> response(:no_content)

      assert response == ""
    end
  end
end
