defmodule TeleCarexWeb.MessageJSON do
  alias TeleCarex.Conversations.Message

  @doc """
  Renders a list of messages.
  """
  def index(%{messages: messages}) do
    %{data: relationship(messages)}
  end

  @doc """
  Renders a single message.
  """
  def show(%{message: message}) do
    %{data: relationship(message)}
  end

  def relationship(%Message{} = message) do
    data(message)
  end

  def relationship(messages) when is_list(messages) do
    for(message <- messages, do: data(message))
  end

  defp data(%Message{} = message) do
    Map.take(message, [:id, :content, :internal?, :conversation_id, :created_by_id])
  end
end
