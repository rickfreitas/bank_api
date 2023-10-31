defmodule BankApiWeb.AuthenticationJSON do
  def auth(%{api_key: api_key}) do
    %{authorization_key: api_key}
  end
end
