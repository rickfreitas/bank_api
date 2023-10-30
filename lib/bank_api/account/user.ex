defmodule BankApi.Account.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :name, :string
    field :initial_balance, :float
    field :current_balance, :float
    field :cpf, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :cpf, :initial_balance, :current_balance])
    |> validate_required([:name, :cpf, :initial_balance, :current_balance])
    |> unique_constraint(:cpf)
  end
end
