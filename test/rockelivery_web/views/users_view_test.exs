defmodule RockeliveryWeb.UsersViewTest do
  use RockeliveryWeb.ConnCase, async: true

  import Phoenix.View
  import Rockelivery.Factory

  alias RockeliveryWeb.UsersView

  test "renders create.json" do
    user = build(:user)
    token = "valid_token"
    response = render(UsersView, "create.json", user: user, token: token)

    expected_response = %{
      message: "User created!",
      token: token,
      user: %Rockelivery.User{
        address: "Street Test, 69",
        age: 21,
        document_id: "12345678900",
        email: "test@test.com",
        encrypted_password: nil,
        id: nil,
        inserted_at: nil,
        name: "Test",
        password: "123456",
        updated_at: nil,
        zip_code: "10000100"
      }
    }

    assert response == expected_response
  end
end
