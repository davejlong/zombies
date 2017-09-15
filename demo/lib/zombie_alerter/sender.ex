defmodule ZombieAlerter.Sender do
  @moduledoc """
  Sends a message to all subscribers
  """

  alias ZombieAlerter.Subscriptions
  require Logger

  @doc """
  Sends a message
  """
  def send(text) do
    Subscriptions.get_all()
    |> Enum.each(fn(sub) -> send_to(sub, text) end)
  end

  def send_to(sub, message) do
    Logger.info "Sending '#{message}' to #{sub}"
    ExTwilio.Message.create(to: sub, body: message, from: from())
  end

  defp from(), do: ZombieAlerter.get_env!(:zombie_alerter, :sms_from)
end
