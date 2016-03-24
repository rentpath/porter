defmodule Porter.Notifier do
  use GenEvent

  def manager do
    {:ok, pid} = GenEvent.start_link([])
    pid
  end

  def subscribe(pid, callback) do
    GenEvent.add_handler(pid, __MODULE__, [callback])
  end

  def notify(pid, event) do
    GenEvent.notify(pid, event)
  end

  def init([args]) do
    {:ok, %{callback: args}}
  end

  def handle_event({status, {_, msg}}, state) do
    state.callback.({status, msg})
    {:ok, state}
  end
end
