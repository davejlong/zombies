defmodule Mix.Tasks.Zombie.Server do
    use Mix.Task
    require Logger
  
    @watchers webpack: [bin: "/usr/local/bin/yarn",
                        opts: ["start"]]
  
    @shortdoc "Starts applications and their servers"
    @moduledoc """
    Starts the application
  
    ## Command line options
  
    This task accepts the same command-line arguments as `run`.
    For additional inforamtion, refer to the documentation for
    `Mix.Tasks.Run`
  
    The `--no-halt` flag is automatically added.
    """
    def run(args) do
      if ZombieAlerter.watch_assets?() , do: spawn(&start_watcher/0)
  
      Mix.Task.run "run", run_args() ++ args
    end
  
    defp start_watcher do
      validate_watcher()
  
      Logger.info "Starting asset watcher"
  
      System.cmd watcher_bin(),
                 watcher()[:opts]
    end
  
    defp validate_watcher do
      unless watcher_exists?() do
        Logger.error "Could not start watcher because #{watcher_bin()} could " <>
                     "not be found. Your dashboard server is running, but " <>
                     "assets won't be compiled."
  
        exit(:shutdown)
      end
    end
  
    defp watcher_exists?, do: File.exists? watcher_bin()
  
    defp watcher, do: @watchers[:webpack]
    defp watcher_bin, do: watcher()[:bin] |> Path.expand
  
    defp run_args, do: if iex_running?(), do: [], else: ["--no-halt"]
    defp iex_running?, do: Code.ensure_loaded?(IEx) && IEx.started?
  end
  