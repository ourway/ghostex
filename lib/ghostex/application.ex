defmodule Ghostex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      :hackney_pool.child_spec(:ghostex_pool, timeout: 15_000, max_connections: 100)
      # Starts a worker by calling: Ghostex.Worker.start_link(arg)
      # {Ghostex.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ghostex.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
