defmodule D4Test do
  use ExUnit.Case
  doctest D4

  test "greets the world" do
    assert D4.hello() == :world
  end
end
