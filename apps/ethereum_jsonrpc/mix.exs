defmodule EthereumJsonrpc.MixProject do
  use Mix.Project

  def project do
    [
      aliases: aliases(Mix.env()),
      app: :cypherium_jsonrpc,
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps: deps(),
      deps_path: "../../deps",
      description: "Cypherium JSONRPC client.",
      dialyzer: [
        plt_add_deps: :transitive,
        plt_add_apps: [:mix],
        ignore_warnings: "../../.dialyzer-ignore"
      ],
      elixir: "~> 1.10",
      elixirc_paths: elixirc_paths(Mix.env()),
      lockfile: "../../mix.lock",
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        credo: :test,
        dialyzer: :test
      ],
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      version: "0.1.0"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {CypheriumJSONRPC.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp aliases(env) do
    [
      # to match behavior of `mix test` from project root, which needs to not start applications for `indexer` to
      # prevent its supervision tree from starting, which is undesirable in test
      test: "test --no-start"
    ] ++ env_aliases(env)
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["test/support" | elixirc_paths(:dev)]
  defp elixirc_paths(_), do: ["lib"]

  defp env_aliases(:dev), do: []

  defp env_aliases(_env), do: [compile: "compile --warnings-as-errors"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # CACerts bundle for `CypheriumJSONRPC.WebSocket.WebSocketClient`
      {:certifi, "~> 2.3"},
      # WebSocket-server for testing `CypheriumJSONRPC.WebSocket.WebSocketClient`.
      {:cowboy, "~> 2.0", only: [:dev, :test]},
      # Style Checking
      {:credo, "~> 1.1", only: :test, runtime: false},
      # Static Type Checking
      {:dialyxir, "~> 0.5", only: [:dev, :test], runtime: false},
      # Code coverage
      {:excoveralls, "~> 0.13.3"},
      # JSONRPC HTTP Post calls
      {:httpoison, "~> 1.6"},
      # Decode/Encode JSON for JSONRPC
      {:jason, "~> 1.0"},
      # Log errors and application output to separate files
      {:logger_file_backend, "~> 0.0.10"},
      # Mocking `CypheriumJSONRPC.Transport` and `CypheriumJSONRPC.HTTP` so we avoid hitting real chains for local testing
      {:mox, "~> 0.4", only: [:test]},
      # Tracing
      {:spandex, "~> 3.0"},
      # `:spandex` integration with Datadog
      {:spandex_datadog, "~> 1.0"},
      # Convert unix timestamps in JSONRPC to DateTimes
      {:timex, "~> 3.6"},
      # Encode/decode function names and arguments
      {:ex_abi, "~> 0.4"},
      # `:verify_fun` for `Socket.Web.connect`
      {:ssl_verify_fun, "~> 1.1"},
      # `CypheriumJSONRPC.WebSocket`
      {:websocket_client, "~> 1.3"},
      {:decimal, "~> 1.0"},
      {:decorator, "~> 1.2"},
      {:hackney, "~> 1.16"},
      {:poolboy, "~> 1.5.2"}
    ]
  end
end
