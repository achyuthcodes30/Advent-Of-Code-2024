defmodule D13 do
  def findMinCostEfficient(ax, ay, bx, by, px, py) do
    a = (px * by - py * bx) / (ax * by - ay * bx)
    b = (px - ax * a) / bx

    if a - trunc(a) == 0 and b - trunc(b) == 0 do
      3 * a + b
    else
      0
    end
  end

  def findMinCost(ax, ay, bx, by, px, py) do
    Enum.reduce(0..100, 0, fn i, min ->
      Enum.reduce(0..100, min, fn j, innerMin ->
        x = ax * i + bx * j
        y = ay * i + by * j

        if px == x and py == y do
          cost = 3 * i + j

          if min == 0 or cost < innerMin do
            cost
          else
            innerMin
          end
        else
          innerMin
        end
      end)
    end)
  end

  def tasks do
    File.read("../input")
    |> then(fn {_, string} ->
      String.trim(string)
      |> String.split("\n", trim: true)
      |> Enum.chunk_every(3)
      |> Enum.map(fn list ->
        list
        |> Enum.flat_map(fn string ->
          Regex.scan(~r/\d+/, string)
          |> List.flatten()
        end)
      end)
    end)
    |> then(fn list ->
      Enum.reduce(list, {0, 0}, fn machine, {sum1, sum2} ->
        {ax, ay, bx, by, px1, py1, px2, py2} =
          {String.to_integer(Enum.at(machine, 0)), String.to_integer(Enum.at(machine, 1)),
           String.to_integer(Enum.at(machine, 2)), String.to_integer(Enum.at(machine, 3)),
           String.to_integer(Enum.at(machine, 4)), String.to_integer(Enum.at(machine, 5)),
           String.to_integer(Enum.at(machine, 4)) + 10_000_000_000_000,
           String.to_integer(Enum.at(machine, 5)) + 10_000_000_000_000}

        {sum1 + findMinCostEfficient(ax, ay, bx, by, px1, py1),
         sum2 + findMinCostEfficient(ax, ay, bx, by, px2, py2)}
      end)
    end)
  end
end
