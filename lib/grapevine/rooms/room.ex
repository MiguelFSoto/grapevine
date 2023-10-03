defmodule Grapevine.Rooms.Room do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    field :name, :string
    field :members, {:array, :string}

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name, :members])
    |> validate_required([:name, :members])
  end

  def member_changeset(room, attrs) do
    room
    |> cast(attrs, [:members])
end
