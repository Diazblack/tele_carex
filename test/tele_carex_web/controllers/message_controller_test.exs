defmodule TeleCarexWeb.MessageControllerTest do
  use TeleCarexWeb.ConnCase

  import TeleCarex.ConversationsFixtures

  alias TeleCarex.Conversations.Message

  @create_attrs %{
    content: "some content",
    internal?: true
  }
  @update_attrs %{
    content: "some updated content",
    internal?: false
  }
  @invalid_attrs %{content: nil, internal?: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    @tag :skip
    test "lists all messages", %{conn: conn} do
      conn = get(conn, ~p"/api/messages")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "delete message" do
    setup [:create_message]
    @tag :skip
    test "deletes chosen message", %{conn: conn, message: message} do
      conn = delete(conn, ~p"/api/messages/#{message}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/messages/#{message}")
      end
    end
  end

  defp create_message(_) do
    message = message_fixture()
    %{message: message}
  end
end
