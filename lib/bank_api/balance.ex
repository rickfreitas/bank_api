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
    if validate_transaction(attrs) do
      %BalanceTransaction{}
      |> BalanceTransaction.changeset(attrs)
      |> Repo.insert()
    else 
      {:error, "Invalid transaction"}
    end
  end

  defp validate_transaction(attrs) do
    sender_user_id = attrs["sender_user_id"]
    receiver_user_id = attrs["receiver_user_id"]
    transaction_amount = attrs["transaction_amount"]

    sender_balance = Account.get_user_balance!(sender_user_id)
    receiver_balance = Account.get_user_balance!(receiver_user_id)

    if sender_balance < transaction_amount do
      raise "Insufficient funds"
    end

    if sender_user_id == receiver_user_id do
      raise "Cannot transfer to self"
    end

    if transaction_amount <= 0 do
      raise "Invalid transaction amount"
    end

    if receiver_balance == nil do
      raise "Receiver does not exist"
    end

    sender_user = Account.update_user_balance(sender_user_id, sender_balance - transaction_amount)
    receiver_user = Account.update_user_balance(receiver_user_id, receiver_balance + transaction_amount)

    true
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
end
