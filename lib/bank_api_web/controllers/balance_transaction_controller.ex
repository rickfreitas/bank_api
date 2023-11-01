defmodule BankApiWeb.BalanceTransactionController do
  use BankApiWeb, :controller

  alias BankApi.Account
  alias BankApi.Account.User
  alias BankApi.Balance
  alias BankApi.Balance.BalanceTransaction
  alias BankApi.Utils

  action_fallback BankApiWeb.FallbackController

  plug :authenticate_api_user when action in [:create, :revert_transaction]

  def create(conn, %{"balance_transaction" => balance_transaction_params}) do
    valid_receiver_user_id = Utils.validate_user_id(balance_transaction_params["receiver_user_id"])

    if !valid_receiver_user_id do
      render(conn, :user_error, error: "Invalid receiver user id")
    end

    conn.assigns.current_user
    |> create_balance_transaction(balance_transaction_params, conn)
  end

  defp create_balance_transaction(%User{} = user, balance_transaction_params, conn) do
    balance_transaction_params = Map.put(balance_transaction_params, "sender_user_id", user.id)

    case Balance.create_balance_transaction(balance_transaction_params, user) do
      {:ok, %BalanceTransaction{} = balance_transaction} -> success_response(conn, balance_transaction)
      {:error, %Ecto.Changeset{} = changeset} -> render(conn, :error, changeset: changeset)
      {:error, error} -> render(conn, :transaction_error, error: error)
    end
  end

  def revert_transaction(conn, %{"id" => balance_transaction_id}) do
    case Balance.revert_balance_transaction(balance_transaction_id, conn.assigns.current_user) do
      {:ok, %BalanceTransaction{} = balance_transaction} -> render(conn, :show_reverted, balance_transaction: balance_transaction)
      {:error, %Ecto.Changeset{} = changeset} -> render(conn, :error, changeset: changeset)
      {:error, error} -> render(conn, :transaction_error, error: error)
    end
  end

  defp success_response(conn, balance_transaction) do
    conn
    |> put_status(:created)
    |> put_resp_header("location", ~p"/api/transactions/#{balance_transaction.id}")
    |> render("show.json", balance_transaction: balance_transaction)
  end
end
