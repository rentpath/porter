defmodule PorterTest do
  use ExUnit.Case
  doctest Porter

  #test "it runs a command" do
    #Porter.run("echo \"hello world\"", 
    #assert Porter.run("echo \"hello world\"") == {:ok, 1, ["hello world\n"]}
  #end

  #test "it streams command output" do
    #assert Porter.run("./test/test.sh") == {:ok, 2, ["hello\n", "world\n"]}
  #end
end
