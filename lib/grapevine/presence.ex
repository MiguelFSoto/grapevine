defmodule Grapevine.Presence do
  use Phoenix.Presence, otp_app: :grapevine, pubsub_server: Grapevine.PubSub
end
