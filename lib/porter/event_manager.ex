defmodule Porter.EventManager do
  use GenEvent

  def init(args) do
    {:ok, args}
  end

  def handle_event({:ok, {:data, msg}}, [callback] = state) do
    callback.("Message: #{msg}")
    {:ok, state}
  end

  def handle_event({:ok, {:exit_status, 0}}, [callback]= state) do
    callback.("And we're done!")
    {:ok, state}
  end

  def handle_event({:error, {:exit_status, code}}, [callback] = state) do
    callback.("Something went wrong and exit code #{code} was returned.")
    {:ok, state}
  end
end
