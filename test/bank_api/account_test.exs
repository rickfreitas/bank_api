defmodule BankApi.AccountTest do
  use BankApi.DataCase

  alias BankApi.Account

  describe "users" do
    alias BankApi.Account.User

    import BankApi.AccountFixtures

    @invalid_attrs %{name: nil, balance: nil, cpf: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Account.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Account.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{name: "some name", balance: 120.5, cpf: 42}

      assert {:ok, %User{} = user} = Account.create_user(valid_attrs)
      assert user.name == "some name"
      assert user.balance == 120.5
      assert user.cpf == 42
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{name: "some updated name", balance: 456.7, cpf: 43}

      assert {:ok, %User{} = user} = Account.update_user(user, update_attrs)
      assert user.name == "some updated name"
      assert user.balance == 456.7
      assert user.cpf == 43
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_user(user, @invalid_attrs)
      assert user == Account.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Account.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Account.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Account.change_user(user)
    end
  end
end
