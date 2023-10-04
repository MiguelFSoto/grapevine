defmodule Grapevine.Rooms do
  @moduledoc """
  The Message context.
  """

  import Ecto.Query, warn: false
  alias Grapevine.Repo

  alias Grapevine.Rooms.Room

  @doc """
  Returns a list of rooms that a given user is part of
  """
  # def user_rooms(mail) do
  #   query = from(Room, where:[Enum.member?(:members, mail)], select: [:name])
  #   Repo.all(query)
  # end

  @doc """
  Returns a list of the users in a given room
  """
  # def room_users(room) do
  #   query = from(Room, where:[name: room], select: [:members])
  #   Repo.all(query)
  # end

  @doc """
  Saves a sent message
  """
  def create_room(attrs) do
    %Room{}
    |> Room.changeset(attrs)
    |> Repo.insert()
  end
end
