defmodule TeleCarexWeb.MessageController do
  use TeleCarexWeb, :controller

  alias TeleCarex.Conversations
  alias TeleCarex.Conversations.Message

  action_fallback TeleCarexWeb.FallbackController

  def index(conn, _params) do
    messages = Conversations.list_messages()
    render(conn, :index, messages: messages)
  end

  def delete(conn, %{"id" => id}) do
    message = Conversations.get_message!(id)

    with {:ok, %Message{}} <- Conversations.delete_message(message) do
      send_resp(conn, :no_content, "")
    end
  end
end
