defmodule GrapevineWeb.ChatLive do
  use GrapevineWeb, :live_view

  def mount(_params, _session, socket) do
    defParams = %{messages:  [""], msg: ""}
    {:ok, assign(socket, defParams)}
    # put_resp_cookie(socket, "messages", [], sign: true)
  end

  def handle_event("send_message", %{"messages" => exMessages, "msg" => msgSent}, socket) do
    # %{"messages" => exMessages, "msg" => msgSent} = params
    fullMsgList = [msgSent | exMessages]
    nextParams = %{ messages: fullMsgList, msg: "" }
    {:noreply, assign(socket, nextParams)}
  end
end
