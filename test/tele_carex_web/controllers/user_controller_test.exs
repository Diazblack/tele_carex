defmodule TeleCarexWeb.UserControllerTest do
  use TeleCarexWeb.ConnCase

  import TeleCarex.AccountsFixtures

  describe "index" do
    @tag :skip
    test "lists all users", %{conn: conn} do
      conn = get(conn, ~p"/api/users")
      assert json_response(conn, 200)["data"] == []
    end
  end

  # defp create_user(_) do
  #   user = user_fixture()
  #   %{user: user}
  # end
end
