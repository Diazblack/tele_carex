defmodule TeleCarex.Conversations.Conversation do
  use Ecto.Schema
  import Ecto.Changeset
  alias TeleCarex.Accounts.User
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "conversations" do
    field :title, :string

    # for internal users only
    belongs_to :primary_user, User
    # for public users
    belongs_to :public_user, User

    has_many :messages, TeleCarex.Conversations.Message
    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(conversation, attrs) do
    conversation
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
