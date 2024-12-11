defmodule D3 do
  def mul(string) do
    Regex.scan(~r/mul\((\d+),(\d+)\)/, string)
    |> Enum.reduce(0, fn row, mulAcc ->
      [_, x, y] = row
      multiple = String.to_integer(x) * String.to_integer(y)
      mulAcc + multiple
    end)
  end

  def tasks do
    {_, string} =
      File.read("../input")

    # Task 1
    mul1 = mul(string)

    # Task 2
    {firstDontIndex, _} =
      Regex.scan(~r/don't\(\)/, string, return: :index)
      |> List.first()
      |> List.first()

    {lastDontIndex, _} =
      Regex.scan(~r/don't\(\)/, string, return: :index)
      |> List.last()
      |> List.first()

    initMul2 = mul(String.slice(string, 0..firstDontIndex))

    middleMul2 =
      Regex.scan(~r/do\(\)(.*?)don't\(\)?/s, string)
      |> Enum.reduce(0, fn list, mulAcc ->
        mulAcc + mul(List.first(list))
      end)

    {lastDoIndex, _} =
      Regex.scan(~r/do\(\)/, string, return: :index)
      |> List.last()
      |> List.first()

    lastMul2 =
      if lastDoIndex > lastDontIndex do
        mul(String.slice(string, lastDoIndex..(String.length(string) - 1)))
      else
        0
      end

    {mul1, lastMul2 + initMul2 + middleMul2}
  end
end
