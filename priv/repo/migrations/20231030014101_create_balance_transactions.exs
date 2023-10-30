defmodule BankApi.Repo.Migrations.CreateBalanceTransactions do
  use Ecto.Migration

  def change do
    create table(:balance_transactions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :transaction_amount, :float
      add :reversed, :boolean, default: false, null: false
      add :sender_user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :receiver_user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:balance_transactions, [:sender_user_id])
    create index(:balance_transactions, [:receiver_user_id])
  end
end
