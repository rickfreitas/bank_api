defmodule BankApi.Balance.BalanceTransaction do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "balance_transactions" do
    field :reversed, :boolean, default: false
    field :transaction_amount, :float
    field :sender_user_id, :binary_id
    field :receiver_user_id, :binary_id
    
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(balance_transaction, attrs) do
    balance_transaction
    |> cast(attrs, [:transaction_amount, :reversed, :sender_user_id, :receiver_user_id])
    |> validate_required([:transaction_amount, :sender_user_id, :receiver_user_id])
  end
end
