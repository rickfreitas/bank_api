defmodule BankApi.Balance do
  @moduledoc """
  The Balance context.
  """

  import Ecto.Query, warn: false
  alias BankApi.Repo

  alias BankApi.Balance.BalanceTransaction
  alias BankApi.Account

  @doc """
  Returns the list of balance_transactions.

  ## Examples

      iex> list_balance_transactions()
      [%BalanceTransaction{}, ...]

  """
  def list_balance_transactions do
    Repo.all(BalanceTransaction)
  end

  @doc """
  Gets a single balance_transaction.

  Raises `Ecto.NoResultsError` if the Balance transaction does not exist.

  ## Examples

      iex> get_balance_transaction!(123)
      %BalanceTransaction{}

      iex> get_balance_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_balance_transaction!(id), do: Repo.get!(BalanceTransaction, id)

  @doc """
  Creates a balance_transaction.

  ## Examples

      iex> create_balance_transaction(%{field: value})
      {:ok, %BalanceTransaction{}}

      iex> create_balance_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  def create_balance_transaction(attrs \\ %{}) do
    transaction_amount = attrs["transaction_amount"] |> IO.inspect()
    sender_user_id = attrs["sender_user_id"]
    receiver_user_id = attrs["receiver_user_id"]

    sender_user = Account.get_user!(sender_user_id) |> IO.inspect()
    receiver_user = Account.get_user!(receiver_user_id)

    with {:ok, %{sender_user: _, receiver_user: _, balance_transaction: balance_transaction }}
      <- validate_and_execute_transaction(sender_user, receiver_user, attrs, transaction_amount) do
        {:ok, balance_transaction}
      end
  rescue error ->
    {:error, error}
  end

  def revert_balance_transaction(attrs, request_user) do
    if attrs.reversed do
      raise "Transaction already reversed"
    end

    sender_user = Account.get_user!(attrs.sender_user_id)
    receiver_user = Account.get_user!(attrs.receiver_user_id)

    if sender_user.id != request_user.id do
      raise "User not allowed to revert transaction"
    end

    if receiver_user.current_balance < attrs.transaction_amount do
      raise "Insufficient funds on receiver account"
    end

    with {:ok, %{sender_user: _, receiver_user: _, balance_transaction: balance_transaction }}
      <- execute_reversion_on_db(sender_user, receiver_user, attrs) do
        {:ok, balance_transaction}
      end
    rescue error ->
      {:error, error}
  end

  defp validate_and_execute_transaction(sender_user, receiver_user, attrs, transaction_amount) do
    errors = []
    
    if sender_user.current_balance < transaction_amount do
      raise "Insufficient funds"
    end

    if sender_user.id == receiver_user.id do
      raise "Cannot transfer to self"
    end

    if transaction_amount <= 0 do
      raise "Invalid transaction amount"
    end

    if receiver_user == nil do
      raise "Receiver does not exist"
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

  @doc """
  Updates a balance_transaction.

  ## Examples

      iex> update_balance_transaction(balance_transaction, %{field: new_value})
      {:ok, %BalanceTransaction{}}

      iex> update_balance_transaction(balance_transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_balance_transaction(%BalanceTransaction{} = balance_transaction, attrs) do
    balance_transaction
    |> BalanceTransaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a balance_transaction.

  ## Examples

      iex> delete_balance_transaction(balance_transaction)
      {:ok, %BalanceTransaction{}}

      iex> delete_balance_transaction(balance_transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_balance_transaction(%BalanceTransaction{} = balance_transaction) do
    Repo.delete(balance_transaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking balance_transaction changes.

  ## Examples

      iex> change_balance_transaction(balance_transaction)
      %Ecto.Changeset{data: %BalanceTransaction{}}

  """
  def change_balance_transaction(%BalanceTransaction{} = balance_transaction, attrs \\ %{}) do
    BalanceTransaction.changeset(balance_transaction, attrs)
  end

  def get_balance_trasactions_by_date(user_id, start_date, end_date) do
    query = from(balance_transaction in BalanceTransaction,
      where: balance_transaction.sender_user_id == ^user_id or balance_transaction.receiver_user_id == ^user_id,
      where: balance_transaction.inserted_at >= ^start_date,
      where: balance_transaction.inserted_at <= ^end_date,
      order_by: [asc: balance_transaction.inserted_at]
    )

    Repo.all(query)
  end
end
