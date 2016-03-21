defmodule Echod.Server do
  @options [:binary, packet: :line, active: false, reuseaddr: true]

  def start(port) do
    {:ok, server} = :gen_tcp.listen(port, @options)
    accept_client(server)
  end

  defp accept_client(server) do
    {:ok, client} = :gen_tcp.accept(server)
    read_message(client)
  end

  defp read_message(client) do
    case :gen_tcp.recv(client, 0) do
      {:ok, message} ->
        send_message(message, client)
        read_message(client)
      {:error, _} ->
        :gen_tcp.close(client)
    end
  end

  defp send_message(message, client) do
    :gen_tcp.send(client, message)
  end
end
