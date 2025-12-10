defmodule IntrospectTest do
  use ExUnit.Case
  doctest Introspect

  test "greets the world" do
    assert Introspect.hello() == :world
  end
end
