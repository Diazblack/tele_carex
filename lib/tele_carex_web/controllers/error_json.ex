defmodule TeleCarexWeb.ErrorJSON do
  @moduledoc """
  This module is invoked by your endpoint in case of errors on JSON requests.

  See config/config.exs.
  """

  # If you want to customize a particular status code,
  # you may add your own clauses, such as:
  #
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def render(template, assigns) when is_map_key(assigns, :retry) do
    %{
      errors: %{
        detail: Phoenix.Controller.status_message_from_template(template),
        retry: assigns.retry
      }
    }
  end

  def render(template, _assings) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
