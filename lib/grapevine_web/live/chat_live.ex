defmodule GrapevineWeb.ChatLive do
  use GrapevineWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
