defmodule BankApi.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :cpf, :"varchar(11)"
      add :initial_balance, :float
      add :current_balance, :float
      add :encrypted_password, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:cpf])
  end
end
