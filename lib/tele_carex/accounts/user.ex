defmodule TeleCarex.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :username, :string
    field :available?, :boolean, default: false
    field :role, Ecto.Enum, values: [:internal, :public], default: :public
    field :email, :string

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :role, :available?])
    |> validate_required([:username, :email])
    |> unique_constraint(:email)
  end
end
