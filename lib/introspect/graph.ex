defmodule Introspect.Graph do
  @moduledoc """
  Defines a Journey (https://hexdocs.pm/journey) durable workflow graph
  for "onboarding" customers.
  """
  import Journey.Node

  def new() do
    Journey.new_graph(
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
    )
  end
end
