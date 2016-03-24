defmodule Porter do
  use GenServer

  alias Porter.EventManager

  def start_link do
    {:ok, pid} = GenEvent.start_link([])
    GenServer.start_link(__MODULE__, [pid])
  end

  def run(pid, cmd, callback) do
    GenServer.cast(pid, {:run, cmd, callback})
  end

  def handle_cast({:run, cmd, callback}, [pid] = state) do
    GenEvent.add_handler(pid, EventManager, [callback])
    do_run(cmd, pid)
    {:noreply, state}
  end

  def handle_cast(request, state) do
    super(request, state)
  end

  defp do_run(cmd, pid) do
    port = Port.open({:spawn, cmd}, [:stream, :binary, :exit_status])
    loop(port, pid)
  end

  defp loop(p, pid, count \\ 0, msgs \\ []) do
    receive do
      {p, data} ->
        case data do
          {:data, msg} ->
            GenEvent.notify(pid, {:ok, {:data, msg}})
            loop(p, pid, count+1, [msg | msgs])
          {:exit_status, 0} ->
            GenEvent.notify(pid, {:ok, {:exit_status, 0}})
            {:ok, count, Enum.reverse(msgs)}
          {:exit_status, code} ->
            GenEvent.notify(pid, {:error, {:exit_status, code}})
            {:error, code}
        end
    end
  end
end

#{:ok, {:data, msg}}
#{:ok, {:exit_status, 0}}
#{:error {:exit_status, code}}
