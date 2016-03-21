defmodule EchodTest do
  use ExUnit.Case
  doctest Echod

  setup do
    {:ok, socket} = :gen_tcp.connect('localhost', 10007, [:binary, packet: :line, active: false])
    {:ok, [socket: socket]}
  end

  test "hearing an echo", %{socket: socket} do
    :ok = :gen_tcp.send(socket, "Hello, world!\n")

    case :gen_tcp.recv(socket, 0) do
      {:ok, response} ->
        assert response == "Hello, world!\n"
      {:error, reason} ->
        flunk "Dis not receive response: #{reason}"
    end
  end

  test "sending a carriage return terminates the request", %{socket: socket} do
    :ok = :gen_tcp.send(socket, "Hello, world!\n")
    :ok = :gen_tcp.send(socket, "Hello, world!\n")
    :ok = :gen_tcp.send(socket, "\r\n")

    :gen_tcp.recv(socket, 0) # Returns the first Hello, world!
    :gen_tcp.recv(socket, 0) # Returns the second Hello, world!

    case :gen_tcp.recv(socket, 0) do # Socket should be closed
      {:error, response} ->
        assert response == :closed
    end
  end
end
