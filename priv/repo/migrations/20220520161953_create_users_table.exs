defmodule Rockelivery.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :address, :string
      add :age, :integer
      add :document_id, :string
      add :email, :string
      add :encrypted_password, :string
      add :name, :string
      add :zip_code, :string

      timestamps()
    end

    create unique_index(:users, [:document_id])
    create unique_index(:users, [:email])
  end
end
