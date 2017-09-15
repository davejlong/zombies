defmodule ZombieAlerter.Api do
    @moduledoc """
    API router to handle events from Twilio
    """
  
    require Logger
    use Plug.Router
    alias ZombieAlerter.Sender
    alias ZombieAlerter.Plugs.{TwilioAuth, SenderAuth}
    import ExTwiml
  
    plug Plug.Logger
    plug :match
  
    plug TwilioAuth,
      auth_token: ZombieAlerter.get_env!(:zombie_alerter, :twilio_auth_token)
    plug SenderAuth,
      senders: ZombieAlerter.get_env!(:zombie_alerter, :authed_senders)
    plug :xml_response
  
    plug :dispatch

    post "/sms" do
      message = """
      NEW MESSAGE FROM '#{conn.params["FromCountry"]}':
  
      '#{conn.params["Body"]}'
      """
  
      Task.async(fn() -> Sender.send(message) end)
  
      conn |> send_resp(200, response_body())
    end
  
    match _ do
      send_resp(conn, 404, "Not found")
    end

    defp response_body do
      twiml do
        message "Message received"
      end
    end
  
    defp xml_response(conn, _opts) do
      conn |> put_resp_header("content-type", "text/xml")
    end
  end
  