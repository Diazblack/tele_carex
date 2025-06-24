defmodule TeleCarex.ConversationsTest do
  use TeleCarex.DataCase

  alias TeleCarex.Conversations

  import TeleCarex.AccountsFixtures
  import TeleCarex.ConversationsFixtures

  describe "conversations" do
    alias TeleCarex.Conversations.Conversation

    import TeleCarex.ConversationsFixtures

    @invalid_attrs %{title: nil}

    test "list_conversations/0 returns all conversations" do
      conversation = conversation_fixture()
      assert Conversations.list_conversations() == [conversation]
    end

    test "get_conversation!/1 returns the conversation with given id" do
      conversation = conversation_fixture()
      assert Conversations.get_conversation!(conversation.id).id == conversation.id
    end

    test "create_conversation/1 with valid data creates a conversation" do
      valid_attrs = %{title: "some title"}

      assert {:ok, %Conversation{} = conversation} =
               Conversations.create_conversation(valid_attrs)

      assert conversation.title == "some title"
    end

    test "create_conversation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Conversations.create_conversation(@invalid_attrs)
    end

    test "update_conversation/2 with valid data updates the conversation" do
      conversation = conversation_fixture()
      update_attrs = %{title: "some updated title"}

      assert {:ok, %Conversation{} = conversation} =
               Conversations.update_conversation(conversation, update_attrs)

      assert conversation.title == "some updated title"
    end

    test "update_conversation/2 with invalid data returns error changeset" do
      conversation = conversation_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Conversations.update_conversation(conversation, @invalid_attrs)

      assert conversation.id == Conversations.get_conversation!(conversation.id).id
    end

    test "delete_conversation/1 deletes the conversation" do
      conversation = conversation_fixture()
      assert {:ok, %Conversation{}} = Conversations.delete_conversation(conversation)
      assert nil == Conversations.get_conversation!(conversation.id)
    end

    test "change_conversation/1 returns a conversation changeset" do
      conversation = conversation_fixture()
      assert %Ecto.Changeset{} = Conversations.change_conversation(conversation)
    end
  end

  describe "messages" do
    setup context do
      user = user_fixture()
      conv = conversation_fixture(public_user_id: user.id)

      {:ok, Map.merge(context, %{user: user, conv: conv})}
    end

    alias TeleCarex.Conversations.Message

    import TeleCarex.ConversationsFixtures

    @invalid_attrs %{content: nil, internal?: nil}

    test "list_messages/0 returns all messages", %{user: user, conv: conv} do
      message = message_fixture(%{created_by_id: user.id, conversation_id: conv.id})
      assert Conversations.list_messages() == [message]
    end

    test "get_message!/1 returns the message with given id", %{user: user, conv: conv} do
      message = message_fixture(%{created_by_id: user.id, conversation_id: conv.id})
      assert Conversations.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message", %{user: user, conv: conv} do
      valid_attrs = %{
        content: "some content",
        internal?: true,
        created_by_id: user.id,
        conversation_id: conv.id
      }

      assert {:ok, %Message{} = message} = Conversations.create_message(valid_attrs)
      assert message.content == "some content"
      assert message.internal? == true
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Conversations.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message", %{user: user, conv: conv} do
      message = message_fixture(%{created_by_id: user.id, conversation_id: conv.id})
      update_attrs = %{content: "some updated content", internal?: false}

      assert {:ok, %Message{} = message} = Conversations.update_message(message, update_attrs)
      assert message.content == "some updated content"
      assert message.internal? == false
    end

    test "update_message/2 with invalid data returns error changeset", %{user: user, conv: conv} do
      message = message_fixture(%{created_by_id: user.id, conversation_id: conv.id})
      assert {:error, %Ecto.Changeset{}} = Conversations.update_message(message, @invalid_attrs)
      assert message == Conversations.get_message!(message.id)
    end

    test "delete_message/1 deletes the message", %{user: user, conv: conv} do
      message = message_fixture(%{created_by_id: user.id, conversation_id: conv.id})
      assert {:ok, %Message{}} = Conversations.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Conversations.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset", %{user: user, conv: conv} do
      message = message_fixture(%{created_by_id: user.id, conversation_id: conv.id})
      assert %Ecto.Changeset{} = Conversations.change_message(message)
    end
  end
end
