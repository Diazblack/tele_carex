defmodule TeleCarexWeb.MessageController do
  use TeleCarexWeb, :controller

  alias TeleCarex.Accounts
  alias TeleCarex.Conversations
  alias TeleCarex.Conversations.Message

  action_fallback TeleCarexWeb.FallbackController

  def index(conn, %{"user_id" => user_id}) do
    with {:ok, user} <- Accounts.get_user(user_id) do
      messages = Conversations.list_messages(user.id)
      render(conn, :index, messages: messages)
    end
  end

  def delete(conn, %{"id" => id}) do
    message = Conversations.get_message!(id)

    with {:ok, %Message{}} <- Conversations.delete_message(message) do
      send_resp(conn, :no_content, "")
    end
  end
end
