import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :calculator_lv, CalculatorLvWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "WsEwzej2e0NrubPHdjD5hxX+nQlSVT9Zuotnf+M9Vderz4Z1GK57yMwIXmuP507f",
  server: false

# In test we don't send emails.
config :calculator_lv, CalculatorLv.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
