defmodule D2Test do
  use ExUnit.Case
  doctest D2

  test "greets the world" do
    assert D2.hello() == :world
  end
end
