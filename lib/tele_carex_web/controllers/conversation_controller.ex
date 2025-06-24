defmodule TeleCarexWeb.ConversationController do
  use TeleCarexWeb, :controller

  alias TeleCarex.Accounts
  alias TeleCarex.Accounts.User
  alias TeleCarex.Conversations
  alias TeleCarex.Conversations.Conversation
  alias TeleCarex.Conversations.Message

  action_fallback TeleCarexWeb.FallbackController

  def index(conn, _params) do
    conversations = Conversations.list_conversations()
    render(conn, :index, conversations: conversations)
  end

  def create(conn, %{"conversation" => c_params}) do
    with {:ok, %User{id: u_id}} <-
           Accounts.find_or_create(%{
             "username" => c_params["username"],
             "email" => c_params["email"]
           }),
         {:ok, %Conversation{id: c_id} = conversation} <-
           c_params |> Map.put("public_user_id", u_id) |> Conversations.create_conversation(),
         {:ok, %Message{} = message} <-
           Conversations.create_message(%{
             "conversation_id" => c_id,
             "created_by_id" => u_id,
             "content" => c_params["content"],
             "internal?" => false
           }),
         {:ok, updated_conversation} <- Conversations.assign_primary_to_conversation(conversation) do
      conn
      |> put_status(:created)
      |> render(:show, conversation: %{updated_conversation | messages: [message]})
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, uuid} <- Ecto.UUID.cast(id) do
      conversation = Conversations.get_conversation!(uuid)
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
