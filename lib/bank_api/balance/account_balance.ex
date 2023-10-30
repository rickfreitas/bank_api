defmodule BankApi.Balance.AccountBalance do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "account_balances" do
    field :user_id, :string
    field :inital_balance, :float
    field :current_balance, :float

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(account_balance, attrs) do
    account_balance
    |> cast(attrs, [:user_id, :inital_balance, :current_balance])
    |> validate_required([:user_id, :inital_balance, :current_balance])
  end
end
