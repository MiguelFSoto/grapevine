defmodule Grapevine.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :content, :string
      add :sender, :string

      timestamps()
    end
  end
end
