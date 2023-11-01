defmodule BankApi.Account do
  import Ecto.Query, warn: false
  alias BankApi.Repo

  alias BankApi.Account.User

  def get_user(id), do: Repo.get(User, id)

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end
end
