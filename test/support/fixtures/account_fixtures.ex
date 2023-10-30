defmodule BankApi.AccountFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BankApi.Account` context.
  """

  @doc """
  Generate a unique user cpf.
  """
  def unique_user_cpf, do: System.unique_integer([:positive])

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        balance: 120.5,
        cpf: unique_user_cpf(),
        name: "some name"
      })
      |> BankApi.Account.create_user()

    user
  end
end
