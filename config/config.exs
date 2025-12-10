import Config

config :introspect, ecto_repos: [Journey.Repo]

config :journey, Journey.Repo,
  database: "introspect",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :logger,
       :console,
       format: "$time [$level] $metadata$message\n",
       level: :warning,
       metadata: [:pid, :mfa]
