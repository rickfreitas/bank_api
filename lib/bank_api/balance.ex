defmodule BankApi.Balance do
  @moduledoc """
  The Balance context.
  """

  import Ecto.Query, warn: false
  alias BankApi.Repo

  alias BankApi.Balance.BalanceTransaction
  alias BankApi.Account

  def get_balance_trasactions_by_date(user_id, start_date, end_date) do
    query = from(balance_transaction in BalanceTransaction,
      where: balance_transaction.sender_user_id == ^user_id or balance_transaction.receiver_user_id == ^user_id,
      where: balance_transaction.inserted_at >= ^start_date,
      where: balance_transaction.inserted_at <= ^end_date,
      order_by: [asc: balance_transaction.inserted_at]
    )

    Repo.all(query)
  end

  def create_balance_transaction(attrs \\ %{}, sender_user) do
    transaction_amount = attrs["transaction_amount"]
    receiver_user_id = attrs["receiver_user_id"]

    IO.inspect(receiver_user_id)
    receiver_user = Account.get_user(receiver_user_id)

    with {:ok, %{sender_user: _, receiver_user: _, balance_transaction: balance_transaction }}
      <- validate_and_execute_transaction(sender_user, receiver_user, attrs, transaction_amount) do
        {:ok, balance_transaction}
      end
  rescue error ->
    {:error, error}
  end

  def revert_balance_transaction(balance_transaction_id, request_user) do
    balance_transaction = Repo.get(BalanceTransaction, balance_transaction_id)

    if balance_transaction == nil do
      raise "Transaction does not exist"
    end

    if balance_transaction.reversed do
      raise "Transaction already reversed"
    end

    if balance_transaction.sender_user_id != request_user.id do
      raise "User not allowed to revert transaction"
    end

    receiver_user = Account.get_user(balance_transaction.receiver_user_id)

    if receiver_user.current_balance < balance_transaction.transaction_amount do
      raise "Insufficient funds on receiver account"
    end

    with {:ok, %{sender_user: _, receiver_user: _, balance_transaction: balance_transaction }}
      <- execute_reversion_on_db(request_user, receiver_user, balance_transaction) do
        {:ok, balance_transaction}
      end
    rescue error ->
      {:error, error}
  end

  defp validate_and_execute_transaction(sender_user, receiver_user, attrs, transaction_amount) do
    if sender_user.current_balance < transaction_amount do
      raise "Insufficient funds"
    end
   
    if receiver_user == nil do
      raise "Receiver does not exist"
    end

    if sender_user.id == receiver_user.id do
      raise "Cannot transfer to self"
    end

    if transaction_amount <= 0 do
      raise "Invalid transaction amount"
    end

    execute_database_changes(sender_user, receiver_user, attrs, transaction_amount)
  end

  defp execute_database_changes(sender_user, receiver_user, attrs, transaction_amount) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:sender_user, Account.User.changeset(sender_user, %{"current_balance" => sender_user.current_balance - transaction_amount}))
    |> Ecto.Multi.update(:receiver_user, Account.User.changeset(receiver_user, %{"current_balance" => receiver_user.current_balance + transaction_amount}))
    |> Ecto.Multi.insert(:balance_transaction, BalanceTransaction.changeset(%BalanceTransaction{}, attrs))
    |> Repo.transaction()
  end

  defp execute_reversion_on_db(sender_user, receiver_user, attrs) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:sender_user, Account.User.changeset(sender_user, %{"current_balance" => sender_user.current_balance + attrs.transaction_amount}))
    |> Ecto.Multi.update(:receiver_user, Account.User.changeset(receiver_user, %{"current_balance" => receiver_user.current_balance - attrs.transaction_amount}))
    |> Ecto.Multi.update(:balance_transaction, BalanceTransaction.changeset(attrs, %{"reversed" => true}))
    |> Repo.transaction()
  end
end
