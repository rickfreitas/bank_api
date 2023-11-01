defmodule BankApiWeb.AuthenticationController do
  use BankApiWeb, :controller

  alias BankApi.Account
  alias BankApiWeb.API.Auth
  alias Comeonin.Bcrypt
  alias BankApi.Utils

  action_fallback BankApiWeb.FallbackController

  def auth(conn, %{"id" => id, "password" => password}) do
    valid_id = Utils.validate_user_id(id)

    if !valid_id do
      render_auth_error(conn)
    end

    user = Account.get_user(id)

    validate_password(conn, user, password)
  end

  defp validate_password(conn, nil, _password) do
    render_auth_error(conn)
  end

  defp validate_password(conn, user, password) do
    case Bcrypt.checkpw(password, user.encrypted_password) do
      true -> 
        api_key = Auth.generate_token(user.id)
        render(conn, :auth, api_key: api_key)
      false ->
        render_auth_error(conn)
    end
  end

  defp render_auth_error(conn) do
    conn
    |> put_status(:unauthorized)
    |> render(:auth_error, %{error: "Invalid autentication data"})
  end
end
