defmodule BankApi.BalanceTest do
  use BankApi.DataCase

  alias BankApi.Balance

  describe "account_balances" do
    alias BankApi.Balance.AccountBalance

    import BankApi.BalanceFixtures

    @invalid_attrs %{user_id: nil, inital_balance: nil, current_balance: nil}

    test "list_account_balances/0 returns all account_balances" do
      account_balance = account_balance_fixture()
      assert Balance.list_account_balances() == [account_balance]
    end

    test "get_account_balance!/1 returns the account_balance with given id" do
      account_balance = account_balance_fixture()
      assert Balance.get_account_balance!(account_balance.id) == account_balance
    end

    test "create_account_balance/1 with valid data creates a account_balance" do
      valid_attrs = %{user_id: "some user_id", inital_balance: 120.5, current_balance: 120.5}

      assert {:ok, %AccountBalance{} = account_balance} = Balance.create_account_balance(valid_attrs)
      assert account_balance.user_id == "some user_id"
      assert account_balance.inital_balance == 120.5
      assert account_balance.current_balance == 120.5
    end

    test "create_account_balance/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Balance.create_account_balance(@invalid_attrs)
    end

    test "update_account_balance/2 with valid data updates the account_balance" do
      account_balance = account_balance_fixture()
      update_attrs = %{user_id: "some updated user_id", inital_balance: 456.7, current_balance: 456.7}

      assert {:ok, %AccountBalance{} = account_balance} = Balance.update_account_balance(account_balance, update_attrs)
      assert account_balance.user_id == "some updated user_id"
      assert account_balance.inital_balance == 456.7
      assert account_balance.current_balance == 456.7
    end

    test "update_account_balance/2 with invalid data returns error changeset" do
      account_balance = account_balance_fixture()
      assert {:error, %Ecto.Changeset{}} = Balance.update_account_balance(account_balance, @invalid_attrs)
      assert account_balance == Balance.get_account_balance!(account_balance.id)
    end

    test "delete_account_balance/1 deletes the account_balance" do
      account_balance = account_balance_fixture()
      assert {:ok, %AccountBalance{}} = Balance.delete_account_balance(account_balance)
      assert_raise Ecto.NoResultsError, fn -> Balance.get_account_balance!(account_balance.id) end
    end

    test "change_account_balance/1 returns a account_balance changeset" do
      account_balance = account_balance_fixture()
      assert %Ecto.Changeset{} = Balance.change_account_balance(account_balance)
    end
  end

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
