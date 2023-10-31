defmodule BankApiWeb.BalanceTransactionJSON do
  alias BankApi.Balance.BalanceTransaction

  def show(%{balance_transaction: balance_transaction}) do
    %{
      id: balance_transaction.id,
      sender_user_id: balance_transaction.sender_user_id,
      receiver_user_id: balance_transaction.receiver_user_id,
      transaction_amount: balance_transaction.transaction_amount,
    }
  end

  def show_reverted(%{balance_transaction: balance_transaction}) do
    %{
      id: balance_transaction.id,
      sender_user_id: balance_transaction.sender_user_id,
      receiver_user_id: balance_transaction.receiver_user_id,
      transaction_amount: balance_transaction.transaction_amount,
      reverted: balance_transaction.reversed
    }
  end

  def error(%{changeset: changeset}) do
    %{errors: changeset.errors}
  end

  def user_error(%{error: error}) do
    %{user_error: "Error on UserAuthKey: #{error.message}"}
  end

  def transaction_error(%{error: error}) do
    %{transaction_error: error.message}
  end
end
