defmodule TeleCarexWeb.UserController do
  use TeleCarexWeb, :controller

  alias TeleCarex.Accounts

  action_fallback TeleCarexWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, :index, users: users)
  end
end
