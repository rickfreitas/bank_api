defmodule BankApiWeb.API.Auth do
  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> get_token()
    |> verify_token()
    |> validate_user(conn)
  end

  @doc """
  A function plug that ensures that `:current_user` value is present.

  ## Examples

      # in a router pipeline
      pipe_through [:api, :authenticate_api_user]

      # in a controller
      plug :authenticate_api_user when action in [:index, :create]

  """
  def authenticate_api_user(conn, _opts) do
    if Map.get(conn.assigns, :current_user) do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> put_view(html: BankApiWeb.ErrorHTML, json: BankApiWeb.ErrorJSON)
      |> render(:"401.json")
      |> halt()
    end
  end

  def generate_token(user_id) do
    Phoenix.Token.sign(
      BankApiWeb.Endpoint,
      inspect(__MODULE__),
      user_id
    )
  end

  def verify_token(token) do
    one_month = 30 * 24 * 60 * 60

    Phoenix.Token.verify(
      BankApiWeb.Endpoint,
      inspect(__MODULE__),
      token,
      max_age: one_month
    )
  end

  def get_token(conn) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] -> token
      _ -> nil
    end
  end

  defp validate_user({:ok, user_id}, conn) do
    case BankApi.Account.get_user(user_id) do
      nil -> assign(conn, :current_user, nil)
      user -> assign(conn, :current_user, user)
    end
  end

  defp validate_user(_unauthorized, conn) do
    assign(conn, :current_user, nil)
  end
end
