defmodule TeleCarex.Repo.Migrations.CreateConversations do
  use Ecto.Migration

  def change do
    create table(:conversations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string, null: false
      add :primary_user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :public_user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime_usec)
    end

    create index(:conversations, [:primary_user_id])
    create index(:conversations, [:public_user_id])
  end
end
