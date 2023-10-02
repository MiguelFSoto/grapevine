defmodule GrapevineWeb.ChatLive do
  use GrapevineWeb, :live_view
  alias Grapevine.Messages
  import Ecto.Query

  def mount(_params, _session, socket) do
    fullMsgList = Messages.message_list
    defParams = %{messages:  fullMsgList, msg: ""}
    {:ok, assign(socket, defParams)}
    # put_resp_cookie(socket, "messages", [], sign: true)
  end

  def handle_event("send_message", %{"sender" => sender, "msg" => msgSent}, socket) do
    # %{"messages" => exMessages, "msg" => msgSent} = params
    %{content: msgSent, sender: sender}
    |> Messages.save_message
    fullMsgList = Messages.message_list
    nextParams = %{ messages: fullMsgList, msg: "" }
    {:noreply, assign(socket, nextParams)}
  end
end
