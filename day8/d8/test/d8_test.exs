defmodule D8Test do
  use ExUnit.Case
  doctest D8

  test "greets the world" do
    assert D8.hello() == :world
  end
end
