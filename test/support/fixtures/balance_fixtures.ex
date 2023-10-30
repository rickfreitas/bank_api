defmodule BankApi.BalanceFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BankApi.Balance` context.
  """

  @doc """
  Generate a account_balance.
  """
  def account_balance_fixture(attrs \\ %{}) do
    {:ok, account_balance} =
      attrs
      |> Enum.into(%{
        current_balance: 120.5,
        inital_balance: 120.5,
        user_id: "some user_id"
      })
      |> BankApi.Balance.create_account_balance()

    account_balance
  end

  @doc """
  Generate a balance_transaction.
  """
  def balance_transaction_fixture(attrs \\ %{}) do
    {:ok, balance_transaction} =
      attrs
      |> Enum.into(%{
        reversed: true,
        transaction_amount: 120.5
      })
      |> BankApi.Balance.create_balance_transaction()

    balance_transaction
  end
end
