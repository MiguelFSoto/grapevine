defmodule GrapevineWeb.ChatLive do
  use GrapevineWeb, :live_view
  alias Grapevine.Messages
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
    defParams = %{messages: fullMsgList, msg: "", session_id: session_id}
    {:ok, assign(socket, defParams)}
    # put_resp_cookie(socket, "messages", [], sign: true)
  end

  def handle_event("send_message", %{"sender" => sender, "msg" => msgSent}, socket) do
    # %{"messages" => exMessages, "msg" => msgSent} = params
    %{content: msgSent, sender: sender}
    |> Messages.save_message
    fullMsgList = Messages.message_list
    nextParams = %{ messages: fullMsgList, msg: "" }

    MessageServer.set_messages(socket.assigns.session_id, fullMsgList)
    # {:noreply, assign(socket, nextParams)}
    {:noreply, socket}
  end

  def handle_info({:updated_msg, messages}, socket) do
    nextParams = %{ messages: messages, msg: "" }
    {:noreply, assign(socket, nextParams)}
  end
end
