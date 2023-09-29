defmodule Grapevine.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :name, :string
      add :members, {:array, :string}

      timestamps()
    end
  end
end
