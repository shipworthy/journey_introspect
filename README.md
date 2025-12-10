# Introspect

This is a tiny demo project for Journey's introspection functionality.

## Setup

The project expects PostgreSQL. You can run an ephemeral instance in Docker:

```
$ docker run --rm --name postgres -p 5432:5432 -e POSTGRES_PASSWORD=postgres -d postgres:16
```

Followed by the usual Elixir / Ecto setup / test run:

```
$ mix deps.get
$ mix ecto.create
$ mix test
```

## IEx Example

Here is an IEx walkthrough of creating a graph, and starting an execution.

As the execution is moving through its stages, we use `Journey.Tools.introspect/1` to understand its state. Has `:greeting` computation taken place? If not, why not?

(Some output removed for brevity.)

```elixir
$ iex -S mix
iex(1)> import Journey.Node
iex(2)> graph = Journey.new_graph(
  "Onboarding",
  [
    input(:name),
    input(:email_address),
    compute(
      :greeting,
      [:name, :email_address],
      fn values ->
        welcome = "Welcome, #{values.name} at #{values.email_address}"
        IO.puts(welcome)
        {:ok, welcome}
      end
    )
  ]
); :ok

iex(3)> e = Journey.start(graph); :ok

iex(4)> Journey.set(e, :name, "Moomin"); :ok

iex(5)> Journey.Tools.introspect(e.id) |> IO.puts(); :ok
Values:
- Set:
  - name: '"Moomin"' | :input
    set at 2025-12-10 09:02:16Z | rev: 1

- Not set:
  - email_address: <unk> | :input
  - greeting: <unk> | :compute

- Outstanding:
  - greeting: ⬜ :not_set (not yet attempted) | :compute
       :and
        ├─ ✅ :name | &provided?/1 | rev 1
        └─ 🛑 :email_address | &provided?/1

iex(6)> Journey.set(e, :email_address, "moomin@gojourney.dev"); :ok
Welcome, Moomin at moomin@gojourney.dev

iex(7)> Journey.Tools.introspect(e.id) |> IO.puts(); :ok
Values:
- Set:
  - greeting: '"Welcome, Moomin at moomin@gojourney.dev"' | :compute
    computed at 2025-12-10 09:03:06Z | rev: 4

  - email_address: '"moomin@gojourney.dev"' | :input
    set at 2025-12-10 09:03:06Z | rev: 2

  - name: '"Moomin"' | :input
    set at 2025-12-10 09:02:16Z | rev: 1

Computations:
- Completed:
  - :greeting (CMPR7RL0T7T2VTJAG9Z0748): ✅ :success | :compute | rev 4
    inputs used:
       :name (rev 1)
       :email_address (rev 2)
```

## References

Journey: https://hexdocs.pm/journey
