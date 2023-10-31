defmodule BankApiWeb.AuthenticationController do
  use BankApiWeb, :controller

  alias BankApi.Account
  alias BankApi.Account.User
  alias BankApi.Balance
  alias BankApiWeb.API.Auth
  alias Comeonin.Bcrypt

  action_fallback BankApiWeb.FallbackController

  def auth(conn, %{"id" => id, "password" => password}) do
    valid_id = match?({:ok, _}, Ecto.UUID.dump(id))

    if !valid_id do
      render(conn, :auth_error, %{error: "Invalid autentication data"})
    end

    user = Account.get_user(id)

    validate_password(conn, user, password)
  end

  defp validate_password(conn, nil, _password), do: render(conn, :auth_error, %{error: "Invalid autentication data"})

  defp validate_password(conn, user, password) do
    case Bcrypt.checkpw(password, user.encrypted_password) do
      true -> 
        api_key = Auth.generate_token(user.id)
        render(conn, :auth, api_key: api_key)
      false ->
        render(conn, :auth_error, %{error: "Invalid autentication data"})
    end
  end
end
