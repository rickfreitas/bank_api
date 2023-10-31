defmodule BankApiWeb.AuthenticationJSON do
  def auth(%{api_key: api_key}) do
    %{authorization_key: api_key}
  end

  def auth_error(%{error: message}) do
    %{authorization_error: message}
  end
end
