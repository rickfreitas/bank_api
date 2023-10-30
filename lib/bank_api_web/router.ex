defmodule BankApiWeb.Router do
  use BankApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug BankApiWeb.API.Auth
  end

  scope "/api", BankApiWeb do
    pipe_through [:api, :authenticate_api_user]

    resources "/users", UserController, except: [:new, :edit]
  end
end
