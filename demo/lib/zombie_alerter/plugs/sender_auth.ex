defmodule ZombieAlerter.Plugs.SenderAuth do
    @moduledoc """
    Authenticates alerts are sent by an authorized agent.
    """
  
    import Plug.Conn
    import ExTwiml
  
    def init(opts), do: opts
  
    def call(conn, opts) do
      if conn.params["From"] in senders(opts) do
        conn
      else
        conn
        |> put_resp_header("content-type", "text/xml")
        |> send_resp(200, block_message())
        |> halt
      end
    end
  
    defp senders(opts), do: opts[:senders]
    defp block_message() do
      twiml do
        message "You are not authorized to send an alert. The authorities have been notified."
      end
    end
  end
  