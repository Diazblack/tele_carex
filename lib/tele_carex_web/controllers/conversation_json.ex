defmodule TeleCarexWeb.ConversationJSON do
  alias TeleCarex.Conversations.Conversation
  alias TeleCarexWeb.MessageJSON

  @doc """
  Renders a list of conversations.
  """
  def index(%{conversations: conversations}) do
    %{data: for(conversation <- conversations, do: data(conversation))}
  end

  @doc """
  Renders a single conversation.
  """
  def show(%{conversation: conversation}) do
    %{data: data(conversation)}
  end
  # def show(%{conversation: conversation, messages: messages}) do

  #   %{data: data(conversation, messages)}
  # end

  defp data(%Conversation{messages: messages} = conv) do
    conv |> do_data |> Map.put(:messages, do_messages(messages))
  end

  defp data(%Conversation{} = conv),  do: do_data(conv)

  defp do_data(conv) do
    Map.take(conv, [:id, :title])
  end

  defp do_messages(item), do: MessageJSON.relationship(item)
end
