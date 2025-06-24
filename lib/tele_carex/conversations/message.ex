defmodule TeleCarex.Conversations.Message do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "messages" do
    field :content, :string
    field :internal?, :boolean, default: false

    belongs_to :created_by, TeleCarex.Accounts.User
    belongs_to :conversation, TeleCarex.Conversations.Conversation

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content, :internal?, :conversation_id, :created_by_id])
    |> validate_required([:content])
    |> foreign_key_constraint(:conversation_id)
    |> foreign_key_constraint(:created_by_id)
  end
end
