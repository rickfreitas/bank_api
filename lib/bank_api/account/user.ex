defmodule BankApi.Account.User do
  use Ecto.Schema
  alias Comeonin.Bcrypt

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :name, :string
    field :initial_balance, :float
    field :current_balance, :float
    field :cpf, :string
    field :encrypted_password, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :cpf, :initial_balance, :current_balance, :encrypted_password])
    |> validate_required([:name, :cpf, :initial_balance, :current_balance, :encrypted_password])
    |> IO.inspect()
    |> update_change(:encrypted_password, &Bcrypt.hashpwsalt/1)
    |> unique_constraint(:cpf)
  end
end
