defmodule ZombieAlerter.Plugs.TwilioAuth do
    @moduledoc """
    Authenticates requests are coming from Twilio via the request
    signature.
  
    See: https://www.twilio.com/docs/api/security#validating-requests
  
    Usage:
  
    In your router, add the following:
  
        plug :match
  
        # Add the following
        plug ZombieAlerter.Plugs.Authentication
  
        plug :dispatch
    """
  
    import Plug.Conn
  
    @signature_key "x-twilio-signature"
  
    def init(opts), do: opts
  
    def call(conn, opts) do
      signature = sign(conn, auth_token(opts))
      if signature == get_req_signature(conn) do
        conn
      else
        conn |> send_resp(401, "") |> halt
      end
    end
  
    defp auth_token(opts), do: opts[:auth_token]
  
    defp url(conn), do: "#{proto(conn)}://#{conn.host}#{conn.request_path}"
    defp proto(conn) do
      if header = get_req_header(conn, "x-forwarded-proto") do
        header
      else
        conn.scheme |> Atom.to_string
      end
    end
  
    defp get_req_signature(conn), do: conn |> get_req_header(@signature_key) |> List.first
  
    defp sign(conn, auth_token) do
      params = conn.params
      |> Map.delete("glob")
      |> Map.to_list
      |> List.keysort(0)
      |> Enum.map_join("", fn({key, value}) -> "#{key}#{value}" end)
  
      data = "#{url(conn)}#{params}"
  
      :crypto.hmac(:sha, auth_token, data)
      |> Base.encode64
    end
  end
  