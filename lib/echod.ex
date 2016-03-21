defmodule Echod do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(Task, [Echod.Server, :start, [10007]])
    ]

    opts = [strategy: :one_for_one, name: Echod.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
