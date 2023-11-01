defmodule BankApi.Utils do
  def validate_user_id(id) do
    match?({:ok, _}, Ecto.UUID.dump(id))
  end
end