defmodule TeleCarexWeb.ConversationController do
  use TeleCarexWeb, :controller

  alias TeleCarex.Conversations
  alias TeleCarex.Conversations.Conversation

  action_fallback TeleCarexWeb.FallbackController

  def index(conn, _params) do
    conversations = Conversations.list_conversations()
    render(conn, :index, conversations: conversations)
  end

  def create(conn, %{"conversation" => conversation_params}) do
    with {:ok, %Conversation{} = conversation} <- Conversations.create_conversation(conversation_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/conversations/#{conversation}")
      |> render(:show, conversation: conversation)
    end
  end

  def show(conn, %{"id" => id}) do
    conversation = Conversations.get_conversation!(id)
    render(conn, :show, conversation: conversation)
  end

  def update(conn, %{"id" => id, "conversation" => conversation_params}) do
    conversation = Conversations.get_conversation!(id)

    with {:ok, %Conversation{} = conversation} <- Conversations.update_conversation(conversation, conversation_params) do
      render(conn, :show, conversation: conversation)
    end
  end

  def delete(conn, %{"id" => id}) do
    conversation = Conversations.get_conversation!(id)

    with {:ok, %Conversation{}} <- Conversations.delete_conversation(conversation) do
      send_resp(conn, :no_content, "")
    end
  end
end
