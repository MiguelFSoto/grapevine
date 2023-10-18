defmodule GrapevineWeb.ChatLive do
  use GrapevineWeb, :live_view
  alias Grapevine.Messages
  alias Grapevine.Rooms
  alias Grapevine.Presence
  alias Grapevine.MessageServer

  def mount(_params, %{"session_id" => session_id}, socket) do
    if connected?(socket) do
      # As soon as a new instance if the LiveView is mounted, track the session id
      {:ok, _} = Presence.track(self(), "grapevine:presence", session_id, %{
        session_id: session_id,
        joined_at: :os.system_time(:seconds)
      })

      MessageServer.subscribe(session_id)
    end

    fullMsgList = Messages.message_list
    fullRoomList = Rooms.room_list
    defParams = %{
      messages: [],
      msg: "",
      session_id: session_id,
      rooms: fullRoomList,
      activeRoom: ""
    }
    {:ok, assign(socket, defParams)}
  end

  def handle_event("send_message", %{"sender" => sender, "msg" => msgSent}, socket) do
    # %{"messages" => exMessages, "msg" => msgSent} = params
    activeRoom = socket.assigns.activeRoom
    %{ content: msgSent, sender: sender, room: activeRoom }
    |> Messages.save_message
    fullMsgList = Rooms.room_messages(activeRoom)
    # nextParams = %{ messages: fullMsgList, msg: "" }

    MessageServer.set_messages(socket.assigns.session_id, fullMsgList)
    # {:noreply, assign(socket, nextParams)}
    {:noreply, socket}
  end

  def handle_event("create_room", %{"name" => name, "members" => members}, socket) do
    %{name: name, members: [members]}
    |> Rooms.create_room

    fullRoomList = Rooms.room_list
    nextParams = %{ rooms: fullRoomList, name: "" }
    {:noreply, assign(socket, nextParams)}
  end

  def handle_event("select_room", %{"name" => name}, socket) do
    roomMessages = Rooms.room_messages(name)
    nextParams = %{ activeRoom: name, messages: roomMessages }
    {:noreply, assign(socket, nextParams)}
  end

  def handle_info({:updated_msg, messages}, socket) do
    nextParams = %{ messages: messages, msg: "" }
    {:noreply, assign(socket, nextParams)}
  end
end
