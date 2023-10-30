defmodule BankApi.BalanceTest do
  use BankApi.DataCase

  alias BankApi.Balance

  describe "balance_transactions" do
    alias BankApi.Balance.BalanceTransaction

    import BankApi.BalanceFixtures

    @invalid_attrs %{reversed: nil, transaction_amount: nil}

    test "list_balance_transactions/0 returns all balance_transactions" do
      balance_transaction = balance_transaction_fixture()
      assert Balance.list_balance_transactions() == [balance_transaction]
    end

    test "get_balance_transaction!/1 returns the balance_transaction with given id" do
      balance_transaction = balance_transaction_fixture()
      assert Balance.get_balance_transaction!(balance_transaction.id) == balance_transaction
    end

    test "create_balance_transaction/1 with valid data creates a balance_transaction" do
      valid_attrs = %{reversed: true, transaction_amount: 120.5}

      assert {:ok, %BalanceTransaction{} = balance_transaction} = Balance.create_balance_transaction(valid_attrs)
      assert balance_transaction.reversed == true
      assert balance_transaction.transaction_amount == 120.5
    end

    test "create_balance_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Balance.create_balance_transaction(@invalid_attrs)
    end

    test "update_balance_transaction/2 with valid data updates the balance_transaction" do
      balance_transaction = balance_transaction_fixture()
      update_attrs = %{reversed: false, transaction_amount: 456.7}

      assert {:ok, %BalanceTransaction{} = balance_transaction} = Balance.update_balance_transaction(balance_transaction, update_attrs)
      assert balance_transaction.reversed == false
      assert balance_transaction.transaction_amount == 456.7
    end

    test "update_balance_transaction/2 with invalid data returns error changeset" do
      balance_transaction = balance_transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = Balance.update_balance_transaction(balance_transaction, @invalid_attrs)
      assert balance_transaction == Balance.get_balance_transaction!(balance_transaction.id)
    end

    test "delete_balance_transaction/1 deletes the balance_transaction" do
      balance_transaction = balance_transaction_fixture()
      assert {:ok, %BalanceTransaction{}} = Balance.delete_balance_transaction(balance_transaction)
      assert_raise Ecto.NoResultsError, fn -> Balance.get_balance_transaction!(balance_transaction.id) end
    end

    test "change_balance_transaction/1 returns a balance_transaction changeset" do
      balance_transaction = balance_transaction_fixture()
      assert %Ecto.Changeset{} = Balance.change_balance_transaction(balance_transaction)
    end
  end
end
