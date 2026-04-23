defmodule Introspect.GraphTest do
  use ExUnit.Case

  test "test-demo, graph introspection" do
    # 1. Start a new execution of the graph.
    graph = Introspect.Graph.new()
    execution = Journey.start(graph)

    # 2. We have the name, and we can introspect the execution.
    Journey.set(execution, :name, "Snuffkin")
    introspection = Journey.Tools.introspect(execution.id)

    # :greeting is waiting for :email_address
    assert introspection =~ """
             - greeting: ⬜ :not_set (not yet attempted) | :compute
                  :and
                   ├─ ✅ :name | &provided?/1 | rev 1
                   └─ 🛑 :email_address | &provided?/1\
           """

    introspection |> IO.puts()

    # 3. User provides their email address.
    Journey.set(execution, :email_address, "snuffkin@gojourney.dev")
    {:ok, greeting, _} = Journey.get(execution, :greeting, wait: :any)

    introspection = Journey.Tools.introspect(execution.id)
    # With both :name and :email_address now in place, :greeting has computed!
    introspection |> IO.puts()

    assert introspection =~ ~r"""
             - :greeting \([A-Z0-9]+\): ✅ :success \| :compute \| rev 4
               started: .+ \| completed: .+ \(\d+s\)
               inputs used:
                  :name \(rev 1\)
                  :email_address \(rev 2\)\
           """

    # 4. Verifying the actual greeting.
    assert greeting == "Welcome, Snuffkin at snuffkin@gojourney.dev"
  end
end
