defmodule Truckdb.Repo do
  use Ecto.Repo,
    otp_app: :truckdb,
    adapter: Ecto.Adapters.Postgres
end
