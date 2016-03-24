defmodule Porter do

  def run(cmd, callbacks) do
    {:ok, pid} = start_link
    GenServer.cast(pid, {:run, cmd, callbacks})
  end

  def handle_cast({:add_callback, callback}, state) do
    Notifier.subscribe(state.events_pid, callback)
    {:noreply, state}
  end

  def handle_cast({:run, cmd}, state) do
    do_run(cmd, state.events_pid)
    {:noreply, state}
  end

  def handle_cast({:run, cmd, callbacks}, state) do
    for callback <- callbacks, do: Notifier.subscribe(state.events_pid, callback)
    handle_cast({:run, cmd}, state)
  end

  def handle_cast(request, state) do
    super(request, state)
  end

  defp do_run(cmd, pid) do
    port = Port.open({:spawn, cmd}, [:stream, :binary, :exit_status])
    loop(port, pid)
  end

  defp loop(port, pid) do
    receive do
      {port, data} -> handle_data(port, pid, data)
    end
  end

  defp handle_data(port, pid, data) do
    case data do
      {:data, msg} ->
        notify(pid, {:ok, {:data, msg}})
        loop(port, pid)
      {:exit_status, 0} ->
        notify(pid, {:ok, {:exit_status, 0}})
      {:exit_status, code} ->
        notify(pid, {:error, {:exit_status, code}})
    end
  end

  defp notify(pid, message), do: Notifier.notify(pid, message)
end
