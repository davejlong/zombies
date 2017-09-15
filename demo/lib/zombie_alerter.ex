defmodule ZombieAlerter do
  @moduledoc """
  Zombie's are coming! ZombieAlerter helps get the word out about
  the coming invation.
  """

  @doc "Should asset watcher run?"
  def watch_assets?, do: Application.get_env(:zombie_alerter, :watch_assets, false)
  
  @doc """
  Gets a value from the Application environment with support for runtime System
  variables.

  # Examples

      iex> ZombieAlerter.get_env(:zombie_alerter, :foo, "bar")
      {:ok, "bar"}
      iex> Application.put_env(:zombie_alerter, :hello, "world")
      ...> ZombieAlerter.get_env(:zombie_alerter, :hello)
      {:ok, "world"}
  """
  def get_env(app, key, default \\ nil) do
    Application.get_env(app, key, default)
    |> get_env
  end

  @doc """
  Like `get_env/3`, but just returns value instead of tuple
  """
  def get_env!(app, key, default \\ nil) do
    {_, value} = get_env(app, key, default)
    value
  end

  defp get_env({:system, var}) do
    case System.get_env(var) do
      nil -> {:error, :not_set}
      value -> {:ok, value}
    end
  end
  defp get_env(value), do: {:ok, value}
end
