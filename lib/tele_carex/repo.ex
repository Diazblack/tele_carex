defmodule TeleCarex.Repo do
  use Ecto.Repo,
    otp_app: :tele_carex,
    adapter: Ecto.Adapters.Postgres
end
