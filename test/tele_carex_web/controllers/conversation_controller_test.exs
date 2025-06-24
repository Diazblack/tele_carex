defmodule TeleCarexWeb.ConversationControllerTest do
  use TeleCarexWeb.ConnCase

  import Ecto.Query
  import TeleCarex.AccountsFixtures
  import TeleCarex.ConversationsFixtures

  alias TeleCarex.Accounts.User
  alias TeleCarex.Repo

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
    test "creates new conversation entry and public user when data is valid", %{conn: conn} do
      params = %{
        title: "Cold symptoms",
        username: "ElweVohnEsse",
        email: "elwe.vohn@esse.com",
        content: "Some long text"
      }

      conn = post(conn, ~p"/api/conversations", conversation: params)
      new_conv = json_response(conn, 201)["data"]
      [message] = new_conv["messages"]

      assert new_conv["title"] == params.title
      assert message["content"] == params.content
      assert %User{} = Repo.get_by(User, username: params.username)
    end

    test "creates new conversation entry when data is valid and the user exists in the DB", %{
      conn: conn
    } do
      user = user_fixture(%{username: "Jed.Y.Knight", role: :public})

      params = %{
        title: "Stomachache",
        username: user.username,
        email: user.email,
        content: "Some long text"
      }

      conn = post(conn, ~p"/api/conversations", conversation: params)
      new_conv = json_response(conn, 201)["data"]
      [message] = new_conv["messages"]

      assert new_conv["title"] == params.title
      assert message["content"] == params.content
      assert from(u in User, where: u.username == ^user.username) |> Repo.one()
    end

    test "creates a new conversation and assigns it to the next available internal user", %{
      conn: conn
    } do
      primary = user_fixture(%{username: "Frank.N.stein", role: :internal, available?: true})
      user = user_fixture()

      params = %{
        title: "Food poisoning",
        username: user.username,
        email: user.email,
        content: "Some long text"
      }

      conn = post(conn, ~p"/api/conversations", conversation: params)
      conv = json_response(conn, 201)["data"]
      [message] = conv["messages"]

      assert conv["title"] == params.title
      assert message["content"] == params.content
      assert conv["primary_user_id"] == primary.id
    end

    test "renders errors when data is invalid and signal the client to not retry", %{conn: conn} do
      conn = post(conn, ~p"/api/conversations", conversation: @invalid_attrs)
      response = json_response(conn, 422)
      [retry_after] = get_resp_header(conn, "retry-after")
      assert response["errors"] != %{}
      assert retry_after == "false"
      assert response["retry"] == false
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
