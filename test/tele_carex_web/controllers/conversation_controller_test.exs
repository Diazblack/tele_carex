defmodule TeleCarexWeb.ConversationControllerTest do
  use TeleCarexWeb.ConnCase

  import TeleCarex.ConversationsFixtures

  alias TeleCarex.Conversations.Conversation

  @create_attrs %{
    title: "some title"
  }
  @update_attrs %{
    title: "some updated title"
  }
  @invalid_attrs %{title: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    @tag :skip
    test "lists all conversations", %{conn: conn} do
      conn = get(conn, ~p"/api/conversations")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create conversation" do
    test "renders conversation when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/conversations", conversation: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/conversations/#{id}")

      assert %{
               "id" => ^id,
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/conversations", conversation: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete conversation" do
    setup [:create_conversation]
    @tag :skip
    test "deletes chosen conversation", %{conn: conn, conversation: conversation} do
      conn = delete(conn, ~p"/api/conversations/#{conversation}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/conversations/#{conversation}")
      end
    end
  end

  defp create_conversation(_) do
    conversation = conversation_fixture()
    %{conversation: conversation}
  end
end
