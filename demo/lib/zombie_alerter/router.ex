defmodule ZombieAlerter.Router do
    @moduledoc """
    Core router for Zombie Alert application
    """
  
    require Logger
    use Plug.Router
  
    alias ZombieAlerter.{Subscriptions, Api}
  
    plug Plug.Logger
    plug :match
    plug Plug.Parsers, parsers: [:urlencoded]
  
    plug Plug.Static,
      from: "priv/static",
      at: "/assets",
      gzip: true
  
    plug :dispatch

    get "/" do
      body = EEx.eval_file("lib/zombie_alerter/templates/index.html.eex", title: "Zombie Alerter!")

      send_resp(conn, 200, body)
    end

    post "/subscribe" do
      phone_number = Regex.replace(~r/\D/, conn.params["phonenumber"], "")
      Logger.info("New Subscriber #{phone_number}")
      Subscriptions.subscribe(phone_number)
  
      send_resp(conn, 201, "")
    end
  
    get "/subscribers" do
      Subscriptions.get_all()
      |> MapSet.to_list
      |> Poison.encode
      |> case do
        {:ok, numbers} -> conn |> send_json(200, numbers)
        {:error, _} -> conn |> send_json(500, "{}")
      end
    end

    forward "/api", to: Api
  
    match _ do
      send_resp(conn, 404, "Not found")
    end
    
    defp send_json(conn, status, body) do
      conn |> put_resp_header("content-type", "application/json") |> send_resp(status, body)
    end
  end
  