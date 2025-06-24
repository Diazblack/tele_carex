defmodule TeleCarexWeb.Router do
  use TeleCarexWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TeleCarexWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TeleCarexWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/api", TeleCarexWeb do
    pipe_through :api

    resources "/conversations", ConversationController, only: [:index, :show, :create, :delete]
    resources "/messages", MessageController, only: [:create]
    get "/messages/:user_id", MessageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", TeleCarexWeb do
  #   pipe_through :api
  # end

  # # Enable LiveDashboard and Swoosh mailbox preview in development
  # if Application.compile_env(:tele_carex, :dev_routes) do
  #   # If you want to use the LiveDashboard in production, you should put
  #   # it behind authentication and allow only admins to access it.
  #   # If your application does not have an admins-only section yet,
  #   # you can use Plug.BasicAuth to set up some basic authentication
  #   # as long as you are also using SSL (which you should anyway).
  #   import Phoenix.LiveDashboard.Router

  #   scope "/dev" do
  #     pipe_through :browser

  #     live_dashboard "/dashboard", metrics: TeleCarexWeb.Telemetry
  #     forward "/mailbox", Plug.Swoosh.MailboxPreview
  #   end
  # end
end
