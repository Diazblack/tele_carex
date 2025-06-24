defmodule TeleCarex.ConversationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TeleCarex.Conversations` context.
  """

  @doc """
  Generate a conversation.
  """
  def conversation_fixture(attrs \\ %{}) do
    {:ok, conversation} =
      attrs
      |> Enum.into(%{
        title: "some title"
      })
      |> TeleCarex.Conversations.create_conversation()

    conversation
  end
end
