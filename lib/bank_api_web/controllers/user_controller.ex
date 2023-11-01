defmodule BankApiWeb.UserController do
  use BankApiWeb, :controller
  use Timex

  alias BankApi.Account
  alias BankApi.Account.User
  alias BankApi.Balance

  action_fallback BankApiWeb.FallbackController

  plug :authenticate_api_user when action in [:trasactions_by_user, :show, :update, :delete]

  def create(conn, %{"user" => user_params}) do
    create_user_params = user_params
    |> Map.put("initial_balance", user_params["balance"])
    |> Map.put("current_balance", user_params["balance"])
    |> Map.put("encrypted_password", user_params["password"])
    |> Map.delete("balance")

    with {:ok, %User{} = user} <- Account.create_user(create_user_params) do
      conn
      |> put_status(:created)
      |> render(:show, user: user)
    end
  end

  def trasactions_by_user(conn, %{"start" => start_date, "end" => end_date}) do
    user_id = conn.assigns.current_user.id

    {start_date_range, end_date_range} = convert_date_range(start_date, end_date)

    transactions = Balance.get_balance_trasactions_by_date(user_id, start_date_range, end_date_range)

    render(conn, :show_transactions, %{user: conn.assigns.current_user, transactions: transactions})
  rescue
    _ -> render(conn, :invalid_date_filter, %{start_date: start_date, end_date: end_date})
  end

  def balance_by_user(conn, _) do
    render(conn, :show_balance, %{user: conn.assigns.current_user})
  end

  defp convert_date_range(start_date, end_date) do
    start_date_range = start_of_day(start_date)
    end_date_range = end_of_day(end_date)
    {start_date_range, end_date_range}
  end

  defp start_of_day(date) do
    date
    |> Timex.parse!("{0D}/{0M}/{YYYY}")
    |> Timex.beginning_of_day()
  end

  defp end_of_day(date) do
    date
    |> Timex.parse!("{0D}/{0M}/{YYYY}")
    |> Timex.end_of_day()
  end
end
