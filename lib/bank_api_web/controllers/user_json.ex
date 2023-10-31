defmodule BankApiWeb.UserJSON do
  alias BankApi.Account.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  def show_transactions(%{user: user, transactions: transactions}) do
    %{user: data(user), transactions: group_transactions(user.id, transactions)}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      name: user.name,
      cpf: user.cpf,
      balance: user.current_balance
    }
  end

  defp group_transactions(user_id, transactions) do
    sended_transactions = Enum.filter(transactions, fn transaction -> transaction.sender_user_id == user_id end)
    received_transactions = Enum.filter(transactions, fn transaction -> transaction.receiver_user_id == user_id end)

    %{
      received_transactions: for(received_transaction <- received_transactions, do: format_transaction(received_transaction)),
      sended_transactions: for(sended_transaction <- sended_transactions, do: format_transaction(sended_transaction))
    }
  end

  defp format_transaction(transaction) do
    %{
      transaction_id: transaction.id,
      transaction_amount: transaction.transaction_amount,
      sender_user_id: transaction.sender_user_id,
      receiver_user_id: transaction.receiver_user_id,
      transaction_date: transaction.inserted_at,
      reverted: transaction.reversed
    }
  end
end
