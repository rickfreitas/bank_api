defmodule BankApiWeb.UserController do
  use BankApiWeb, :controller

  alias BankApi.Account
  alias BankApi.Account.User
  alias BankApi.Balance

  action_fallback BankApiWeb.FallbackController

  plug :authenticate_api_user when action in [:trasactions_by_user, :show, :update, :delete]

  def index(conn, _params) do
    users = Account.list_users()
    render(conn, :index, users: users)
  end

  def create(conn, %{"user" => user_params}) do
    create_user_params = user_params
    |> Map.put("initial_balance", user_params["balance"])
    |> Map.put("current_balance", user_params["balance"])
    |> Map.put("encrypted_password", user_params["password"])
    |> Map.delete("balance")

    with {:ok, %User{} = user} <- Account.create_user(create_user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Account.get_user!(id)
    render(conn, :show, user: user)
  end

  def trasactions_by_user(conn, _) do
    user_id = conn.assigns.current_user
    user = Account.get_user!(user_id)
    transactions = Balance.get_balance_trasactions(user_id)
    render(conn, :show_transactions, %{user: user, transactions: transactions})
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Account.get_user!(id)

    with {:ok, %User{} = user} <- Account.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Account.get_user!(id)

    with {:ok, %User{}} <- Account.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
