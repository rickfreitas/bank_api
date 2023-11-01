defmodule BankApiWeb.Router do
  use BankApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug BankApiWeb.API.Auth
  end

  scope "/api", BankApiWeb do
    pipe_through [:api]

    post "/auth", AuthenticationController, :auth

    post "/users", UserController, :create

    get "/user_transactions", UserController, :trasactions_by_user
    get "/user_balance", UserController, :balance_by_user

    
    put "/transactions/:id/revert", BalanceTransactionController, :revert_transaction
    post "/transactions", BalanceTransactionController, :create
  end
end
