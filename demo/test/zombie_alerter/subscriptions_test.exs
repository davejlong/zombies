defmodule ZombieAlerterTest.Subscriptions do
    use ExUnit.Case, async: false
  
    alias ZombieAlerter.Subscriptions
  
    test "Can subscribe a number" do
      number = "5555555555"
      {:ok, agent} = Subscriptions.start_link(:sub_test)
      Subscriptions.subscribe(number, agent)
  
      assert number in Subscriptions.get_all(agent)
    end
  end
  