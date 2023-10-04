defmodule Grapevine.MessageServer do
  use GenServer
  alias Grapevine.PubSub

  def init(_opts) do
    Phoenix.PubSub.subscribe(PubSub, "grapevine:presence")

    state = %{}
    {:ok, state}
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def subscribe(session_id), do: Phoenix.PubSub.subscribe(PubSub, "message")

  def set_messages(session_id, messages) do
    GenServer.cast(__MODULE__, {:update_msg, session_id, messages})
  end

  def get_messages(session_id) do
    GenServer.call(__MODULE__, {:get_msg, session_id})
  end

  # Internal interface

  def handle_cast({:update_msg, session_id, messages}, state) do
    Phoenix.PubSub.broadcast(PubSub, "message", {:updated_msg, messages})
    {:noreply, Map.put(state, session_id, messages)}
  end

  def handle_call({:get_msg, session_id}, _from, state) do
    {:reply, Map.get(state, session_id, []), state}
  end

  def handle_info(%Phoenix.Socket.Broadcast{event: "presence_diff", payload: diff}, state) do
    state =
      state
      |> handle_leaves(diff.leaves)

    {:noreply, state}
  end

  defp handle_leaves(state, leaves) do
    Enum.reduce(leaves, state, fn {session_id, _}, state ->
      Grapevine.Presence.list("grapevine:presence")
      |> Map.get(session_id)
      |> case do
        nil -> Map.delete(state, session_id)
        _ -> state
      end
    end)
  end
end
