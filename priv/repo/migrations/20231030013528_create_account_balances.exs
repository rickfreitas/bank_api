defmodule BankApi.Repo.Migrations.CreateAccountBalances do
  use Ecto.Migration

  def change do
    create table(:account_balances, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, :string
      add :inital_balance, :float
      add :current_balance, :float

      timestamps(type: :utc_datetime)
    end
  end
end
