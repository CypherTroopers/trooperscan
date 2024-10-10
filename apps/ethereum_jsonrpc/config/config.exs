use Mix.Config

config :ethereum_jsonrpc, EthereumJSONRPC.RequestCoordinator,
  rolling_window_opts: [
    window_count: 12,
    duration: :timer.minutes(1),
    table: EthereumJSONRPC.RequestCoordinator.TimeoutCounter
  ],
  wait_per_timeout: :timer.seconds(20),
  max_jitter: :timer.seconds(2)

config :ethereum_jsonrpc,
  rpc_transport: if(System.get_env("CYSPHERIUM_JSONRPC_TRANSPORT", "http") == "http", do: :http, else: :ipc),
  ipc_path: System.get_env("IPC_PATH"),
  rpc_url: System.get_env("RPC_URL") || "https://pubnodes.cypherium.io/"

# Add this configuration to add global RPC request throttling.
# throttle_rate_limit: 250,
# throttle_rolling_window_opts: [
#   window_count: 4,
#   duration: :timer.seconds(15),
#   table: EthereumJSONRPC.RequestCoordinator.ThrottleCounter
# ]

config :ethereum_jsonrpc, EthereumJSONRPC.Tracer,
  service: :cypherium_jsonrpc,
  adapter: SpandexDatadog.Adapter,
  trace_key: :cypheriumscan

config :logger, :ethereum_jsonrpc,
  # keep synced with `config/config.exs`
  format: "$dateT$time $metadata[$level] $message\n",
  metadata:
    ~w(application fetcher request_id first_block_number last_block_number missing_block_range_count missing_block_count
       block_number step count error_count shrunk import_id transaction_id)a,
  metadata_filter: [application: :cypherium_jsonrpc]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
