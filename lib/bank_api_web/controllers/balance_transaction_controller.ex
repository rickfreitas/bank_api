defmodule BankApiWeb.BalanceTransactionController do
  use BankApiWeb, :controller

  alias BankApi.Balance
  alias BankApi.Balance.BalanceTransaction

  action_fallback BankApiWeb.FallbackController

  def index(conn, _params) do
    balance_transactions = BalanceTransaction.list_balance_transactions()
    render(conn, :index, balance_transactions: balance_transactions)
  end

  def create(conn, %{"balance_transaction" => balance_transaction_params}) do
    with {:ok, %BalanceTransaction{} = balance_transaction} <- Balance.create_balance_transaction(balance_transaction_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/transactions/#{balance_transaction}")
      |> render(:show, balance_transaction: balance_transaction)
    end
  end

  def show(conn, %{"id" => id}) do
    balance_transaction = Balance.get_balance_transaction!(id)
    render(conn, :show, balance_transaction: balance_transaction)
  end

  def update(conn, %{"id" => id, "balance_transaction" => balance_transaction_params}) do
    balance_transaction = Balance.get_balance_transaction!(id)

    with {:ok, %BalanceTransaction{} = balance_transaction} <- Balance.update_balance_transaction(balance_transaction, balance_transaction_params) do
      render(conn, :show, balance_transaction: balance_transaction)
    end
  end

  def revert_transaction(conn, %{"id" => id}) do
    balance_transaction = Balance.get_balance_transaction!(id)
    balance_transaction_params = %{"reversed" => true}

    with {:ok, %BalanceTransaction{} = balance_transaction} <- Balance.update_balance_transaction(balance_transaction, balance_transaction_params) do
      render(conn, :show, balance_transaction: balance_transaction)
    end
  end

  def delete(conn, %{"id" => id}) do
    balance_transaction = Balance.get_balance_transaction!(id)

    with {:ok, %BalanceTransaction{}} <- Balance.delete_balance_transaction(balance_transaction) do
      send_resp(conn, :no_content, "")
    end
  end
end
