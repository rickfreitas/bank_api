defmodule BankApiWeb.BalanceTransactionJSON do
  alias BankApi.Balance.BalanceTransaction

  @doc """
  Renders a list of users.
  """
  def index(%{balance_transactions: balance_transactions}) do
    %{data: for(balance_transaction <- balance_transactions, do: data(balance_transaction))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{balance_transaction: balance_transaction}) do
    %{data: data(balance_transaction)}
  end

  defp data(%BalanceTransaction{} = balance_transaction) do
    %{
      id: balance_transaction.id,
      sender_user_id: balance_transaction.sender_user_id,
      receiver_user_id: balance_transaction.receiver_user_id,
      transaction_amount: balance_transaction.transaction_amount,
      reversed: balance_transaction.reversed,
    }
  end
end
