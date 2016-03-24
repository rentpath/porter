defmodule Porter.Notifier do
  use GenEvent

  @moduledoc """
  A notifier that calls the provided callbacks belonging to each handler with an argument in the form of a tuple containing a status of either `:ok` or `:error` and a nested tuple containing either the atom `:data` and some binary output or the atom `:exit_status` and an exit code.
  """

  @doc ~S"""
  Start a GenEvent manager and returns its pid.
  """
  @spec manager :: pid
  def manager do
    {:ok, pid} = GenEvent.start_link([])
    pid
  end


  @doc ~S"""
  Add an event handler to the specified manager with a function to be called for each event.
  """
  @spec subscribe(pid :: pid, callback :: fun) :: :ok
  def subscribe(pid, callback) do
    GenEvent.add_handler(pid, __MODULE__, [callback])
  end

  @doc ~S"""
  Notify the specified event manager of an event.
  """
  @spec notify(pid :: pid, event :: {:ok, {atom, String.t | integer}} | {:error, {:exit_status, integer}}) :: :ok
  def notify(pid, event) do
    GenEvent.notify(pid, event)
  end

  @doc ~S"""
  Initialize the Notifier handler by converting the callback in a list to a  map.
  """
  @spec init([fun]) :: {:ok, %{callback: fun}}
  def init([args]) do
    {:ok, %{callback: args}}
  end

  @doc ~S"""
  Invoked when the event manager passes an event to the handler. The callback provided to `init/1` is then called passing in the event data as the argument.
  """
  @spec handle_event({atom, {atom, String.t | integer}}, term) :: {:ok, term}
  def handle_event({status, {_, msg}}, state) do
    state.callback.({status, msg})
    {:ok, state}
  end
end
