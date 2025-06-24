defmodule TeleCarex.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TeleCarex.Accounts` context.
  """

  @doc """
  Generate a unique user email.
  """
  def unique_user_email(str \\ "email"),
    do: "#{str}#{System.unique_integer([:positive])}@test.com"

  @doc """
  Generate a unique user username.
  """
  def unique_user_username, do: "some username#{System.unique_integer([:positive])}"

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    username = unique_user_username()

    {:ok, user} =
      attrs
      |> Enum.into(%{
        available?: true,
        email: unique_user_email(username),
        role: :internal,
        username: username
      })
      |> TeleCarex.Accounts.create_user()

    user
  end
end
