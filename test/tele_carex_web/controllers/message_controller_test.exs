defmodule TeleCarexWeb.MessageControllerTest do
  use TeleCarexWeb.ConnCase

  import TeleCarex.ConversationsFixtures
  import TeleCarex.AccountsFixtures

  setup %{conn: conn} do
    public_user = user_fixture()
    internal_user = user_fixture(%{role: :internal, available?: true})

    conv_1 =
      conversation_fixture(%{public_user_id: public_user.id, primary_user_id: internal_user.id})

    conv_2 =
      conversation_fixture(%{public_user_id: public_user.id, primary_user_id: internal_user.id})

    msg_1 = message_fixture(%{created_by_id: public_user.id, conversation_id: conv_1.id})

    msg_2 =
      message_fixture(%{
        created_by_id: internal_user.id,
        conversation_id: conv_1.id,
        internal?: true
      })

    msg_3 = message_fixture(%{created_by_id: public_user.id, conversation_id: conv_1.id})

    msg_4 =
      message_fixture(%{
        created_by_id: internal_user.id,
        conversation_id: conv_1.id,
        internal?: true
      })

    [
      conn: put_req_header(conn, "accept", "application/json"),
      public_user: public_user,
      internal_user: internal_user,
      conversations: [conv_1, conv_2],
      messages: [msg_1, msg_2, msg_3, msg_4]
    ]
  end

  describe "index" do
    test "lists all the user messages group_by conversation", %{
      conn: conn,
      public_user: pu,
      internal_user: iu
    } do
      conn = get(conn, ~p"/api/messages/#{pu}")
      assert json_response(conn, 200)["data"] |> length == 4

      conn = get(conn, ~p"/api/messages/#{iu}")
      assert json_response(conn, 200)["data"] |> length == 4

      user = user_fixture()
      conn = get(conn, ~p"/api/messages/#{user}")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create" do
    test "creates new message in the conversation when right id is passed", %{
      conn: conn,
      public_user: pu,
      conversations: [c1, _c2]
    } do
      params = %{
        content: Faker.Lorem.Shakespeare.as_you_like_it(),
        created_by_id: pu.id,
        conversation_id: c1.id
      }

      json =
        conn
        |> post(~p"/api/messages/", message: params)
        |> json_response(201)

      response = json["data"]
      assert response["content"] == params.content
      assert response["created_by_id"] == params.created_by_id
      assert response["conversation_id"] == params.conversation_id
      assert response["internal?"] == false
    end

    test "returns an error when incorrect data is passed", %{
      conn: conn
    } do
      params = %{
        content: nil,
        created_by_id: nil,
        conversation_id: nil
      }

      json =
        conn
        |> post(~p"/api/messages/", message: params)
        |> json_response(422)

      assert json["errors"] == %{
               "content" => ["can't be blank"],
               "conversation_id" => ["can't be blank"],
               "created_by_id" => ["can't be blank"]
             }

      assert json["retry"] == false
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
