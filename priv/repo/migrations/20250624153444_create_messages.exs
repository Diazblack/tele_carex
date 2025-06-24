defmodule TeleCarex.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :content, :text, null: false
      add :internal?, :boolean, default: false, null: false
      add :created_by_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :conversation_id, references(:conversations, on_delete: :delete_all, type: :binary_id)

      timestamps(type: :utc_datetime_usec)
    end

    create index(:messages, [:created_by_id])
    create index(:messages, [:conversation_id])
  end
end
