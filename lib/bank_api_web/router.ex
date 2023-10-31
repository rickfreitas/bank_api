defmodule BankApiWeb.Router do
  use BankApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug BankApiWeb.API.Auth
  end

  scope "/api", BankApiWeb do
    pipe_through [:api, :authenticate_api_user]

    get "/users/:id/transactions", UserController, :trasactions_by_user
    resources "/users", UserController, except: [:new, :edit]
    
    put "/transactions/:id/revert", BalanceTransactionController, :revert_transaction
    resources "/transactions", BalanceTransactionController, except: [:new, :edit]

  end
end
