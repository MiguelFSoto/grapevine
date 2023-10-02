defmodule Grapevine.Messages do
  @moduledoc """
  The Message context.
  """

  import Ecto.Query, warn: false
  alias Grapevine.Repo

  alias Grapevine.Messages.Message

  @doc """
  Returns a list of all saved messages
  """
  def message_list() do
    Repo.all(from Message, select: [:content, :sender])
  end

  @doc """
  Saves a sent message
  """
  def save_message(attrs) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end
end
