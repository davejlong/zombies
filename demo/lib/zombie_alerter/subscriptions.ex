defmodule ZombieAlerter.Subscriptions do
    use Agent
  
    @moduledoc """
    Subscription store to collect phone numbers to alert.
    """
  
    @doc "Starts the Subscriptions agent, linked to the current process"
    def start_link(name \\ nil) do
      Agent.start_link(fn -> MapSet.new end, name: name || __MODULE__)
    end
  
    @doc "Subscribes a new phone number for alerts"
    def subscribe(number, agent \\ nil) do
      agent |> get_agent() |> Agent.update(&MapSet.put(&1, number))
    end
  
    @doc "Get's all of the subscribers"
    def get_all(agent \\ nil) do
      agent |> get_agent() |> Agent.get(fn subs -> subs end)
    end
  
    defp get_agent(agent), do: agent || __MODULE__
  end
  