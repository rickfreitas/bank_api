defmodule BankApiWeb.BalanceTransactionController do
  use BankApiWeb, :controller

  alias BankApi.Account
  alias BankApi.Account.User
  alias BankApi.Balance
  alias BankApi.Balance.BalanceTransaction

  action_fallback BankApiWeb.FallbackController

  plug :authenticate_api_user when action in [:create]

  def index(conn, _params) do
    balance_transactions = Balance.list_balance_transactions()
    render(conn, :index, balance_transactions: balance_transactions)
  end

  def create(conn, %{"balance_transaction" => balance_transaction_params}) do
    conn.assigns.current_user
    |> Account.get_user!
    |> handle_validated_user(balance_transaction_params, conn)
  end

  def handle_validated_user(%User{} = user, balance_transaction_params, conn) do
    balance_transaction_params = Map.put(balance_transaction_params, "sender_user_id", user.id)

    case Balance.create_balance_transaction(balance_transaction_params) do
      {:ok, %BalanceTransaction{} = balance_transaction} -> success_response(conn, balance_transaction, :created)
      {:error, %Ecto.Changeset{} = changeset} -> render(conn, :error, changeset: changeset)
      {:error, error} -> render(conn, :transaction_error, error: error)
    end
  end

  def handle_validated_user(Ecto.NoResultsError, _, conn) do
    render(conn, :user_error, error: "User does not exists")
  end

  def handle_validated_user(%{error: error}, _balance_transaction_params, conn) do
    render(conn, :user_error, error: error)
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
    user = Account.get_user(conn.assigns.current_user)

    case user do
      nil -> render(conn, :user_error, error: "User does not exists")
      %User{} = user -> :ok
    end

    balance_transaction = Balance.get_balance_transaction!(id)

    case Balance.revert_balance_transaction(balance_transaction, user) do
      {:ok, %BalanceTransaction{} = balance_transaction} -> render(conn, :show_reverted, balance_transaction: balance_transaction)
      {:error, %Ecto.Changeset{} = changeset} -> render(conn, :error, changeset: changeset)
      {:error, error} -> render(conn, :transaction_error, error: error)
    end
  end

  def delete(conn, %{"id" => id}) do
    balance_transaction = Balance.get_balance_transaction!(id)

    with {:ok, %BalanceTransaction{}} <- Balance.delete_balance_transaction(balance_transaction) do
      send_resp(conn, :no_content, "")
    end
  end

  defp success_response(conn, balance_transaction, status) do
    conn
    |> put_status(status)
    |> put_resp_header("location", ~p"/api/transactions/#{balance_transaction.id}")
    |> render("show.json", balance_transaction: balance_transaction)
  end
end
