defmodule Grapevine.Repo.Migrations.RoomMessages do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :room, :string
    end
  end
end
