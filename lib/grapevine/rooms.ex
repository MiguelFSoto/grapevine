defmodule Grapevine.Rooms do
  @moduledoc """
  The Message context.
  """

  import Ecto.Query, warn: false
  alias Grapevine.Repo

  alias Grapevine.Rooms.Room
  alias Grapevine.Messages.Message

  @doc """
  Returns a list of all rooms
  """
  def room_list do
    query = from(Room, select: [:name])
    Repo.all(query)
  end

  @doc """
  Returns a list of rooms that a given user is part of
  """
  def user_rooms(mail) do
    query = from(r in Room, where: ^mail in r.members, select: [:name])
    Repo.all(query)
  end

  @doc """
  Returns a list of the users in a given room
  """
  def room_users(room) do
    query = from(Room, where: [name: ^room], select: [:members])
    Repo.all(query)
  end

  @doc """
  Returns a list of the messages sent in a given room
  """
  def room_messages(room) do
    query = from(Message, where: [room: ^room], select: [:content, :sender])
    Repo.all(query)
  end

  @doc """
  Saves a room
  """
  def create_room(attrs) do
    %Room{}
    |> Room.changeset(attrs)
    |> Repo.insert()
  end
end
