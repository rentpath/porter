# Porter

Porter provides an OTP application that runs the specified system command using the Erlang Port library and then streams the results back to you.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add porter to your list of dependencies in `mix.exs`:

        def deps do
          [{:porter, "~> 0.0.1"}]
        end

  2. Ensure porter is started before your application:

        def application do
          [applications: [:porter]]
        end

