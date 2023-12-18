defmodule DbService.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Task.Supervisor, name: DbService.TaskSupervisor},
      {
        MyXQL,
        hostname: "127.0.0.1",
        port: 3306,
        database: "hsa1016",
        username: "hsa1016",
        password: "cfltcznmiscnyflwznm0",
        pool_size: 149,
        name: :myxql,
        timeout: 20_000
       },
       {DbService.Cache, :requests_cache}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DbService.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
