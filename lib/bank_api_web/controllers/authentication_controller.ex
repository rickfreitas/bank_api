defmodule BankApiWeb.AuthenticationController do
  use BankApiWeb, :controller

  alias BankApi.Account
  alias BankApi.Account.User
  alias BankApi.Balance
  alias BankApiWeb.API.Auth

  action_fallback BankApiWeb.FallbackController

  def auth(conn, %{"id" => id}) do
    user = Account.get_user!(id)
    api_key =  Auth.generate_token(user.id)
    render(conn, :auth, api_key: api_key)
  end
end
