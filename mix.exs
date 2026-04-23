defmodule Introspect.MixProject do
  use Mix.Project

  def project do
    [
      app: :introspect,
      version: "0.1.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:journey, "~> 0.10.53"},
      {:ecto, "~> 3.12 or ~> 3.13"},
      {:postgrex, "~> 0.20 or ~> 0.21"}
    ]
  end
end
