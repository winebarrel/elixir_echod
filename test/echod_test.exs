defmodule EchodTest do
  use ExUnit.Case
  doctest Echod

  setup do
    {:ok, socket} = :gen_tcp.connect('localhost', 10007, [:binary, packet: :line, active: false])
    {:ok, [socket: socket]}
  end

  test "hearing an echo", %{socket: socket} do
    case :gen_tcp.recv(socket, 0) do
      {:ok, response} ->
        assert response == "Hello, world!\n"
      {:error, reason} ->
        flunk "Dis not receive response: #{reason}"
    end
  end
end
