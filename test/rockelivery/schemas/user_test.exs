defmodule Rockelivery.UserTest do
  use Rockelivery.DataCase, async: true

  import Rockelivery.Factory

  alias Ecto.Changeset
  alias Rockelivery.User
  alias Rockelivery.Users.Create

  describe "changeset/2" do
    test "when all params are valid, returns a valid changeset" do
      params = build(:user_params)

      response = User.changeset(params)

      assert %Changeset{changes: %{name: "Test"}, valid?: true} = response
    end

    test "when updating a changeset, returns a valid changeset with the given changes" do
      params = build(:user_params)

      update_params = %{
        name: "Test 2"
      }

      response = params |> User.changeset() |> User.changeset(update_params)

      assert %Changeset{changes: %{name: "Test 2"}, valid?: true} = response
    end

    test "when updating a user struct, returns a valid changeset with the given changes" do
      {:ok, user} = Create.call(build(:user_params))

      update_params = %{
        name: "Test 2"
      }

      response = User.changeset(user, update_params)

      assert %Changeset{changes: %{name: "Test 2"}, valid?: true} = response
    end

    test "when there are some error, returns an invalid changeset" do
      params = build(:user_params, %{age: 15, password: "123"})

      response = User.changeset(params)

      expected_response = %{
        age: ["must be greater than or equal to 18"],
        password: ["should be at least 6 character(s)"]
      }

      assert errors_on(response) == expected_response
    end
  end
end
