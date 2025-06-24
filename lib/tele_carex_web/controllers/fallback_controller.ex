defmodule TeleCarexWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use TeleCarexWeb, :controller

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: TeleCarexWeb.ChangesetJSON)
    |> put_resp_header("retry-after", "false")
    |> render(:error, changeset: changeset)
  end

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, assigns) when assigns in [{:error, :not_found}, :error] do
    conn
    |> put_status(:not_found)
    |> put_resp_header("retry-after", "false")
    |> put_view(html: TeleCarexWeb.ErrorHTML, json: TeleCarexWeb.ErrorJSON)
    |> render(:"404", %{retry: false})
  end
end
