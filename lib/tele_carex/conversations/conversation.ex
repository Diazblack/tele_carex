defmodule TeleCarex.Conversations.Conversation do
  use Ecto.Schema
  import Ecto.Changeset
  alias TeleCarex.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "conversations" do
    field :title, :string

    belongs_to :primary_user, User
    belongs_to :public_user, User

    has_many :messages, TeleCarex.Conversations.Message
    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(conversation, attrs) do
    conversation
    |> cast(attrs, [:title, :public_user_id, :primary_user_id])
    |> validate_required([:title])
  end
end
