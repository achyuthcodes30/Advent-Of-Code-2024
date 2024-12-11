defmodule D8 do
  def processRow(r, rows, columns, map) do
    Enum.reduce(0..(columns - 1), {MapSet.new(), MapSet.new()}, fn c, {p1, p2} ->
      Enum.reduce(map, {p1, p2}, fn {_, values}, {innerP1, innerP2} ->
        Enum.reduce(values, {innerP1, innerP2}, fn {r1, c1}, {innerpacc_11, innerpacc_12} ->
          Enum.reduce(values, {innerpacc_11, innerpacc_12}, fn {r2, c2},
                                                               {innerpacc_21, innerpacc_22} ->
            if {r1, c1} != {r2, c2} do
              d1 = manhattanDistance(r, c, r1, c1)
              d2 = manhattanDistance(r, c, r2, c2)

              if isCollinear(r, c, r1, c1, r2, c2) and
                   0 <= r and r < rows and 0 <= c and c < columns do
                if d1 * 2 == d2 or d1 == 2 * d2 do
                  {MapSet.put(innerpacc_21, {r, c}), MapSet.put(innerpacc_22, {r, c})}
                else
                  {innerpacc_21, MapSet.put(innerpacc_22, {r, c})}
                end
              else
                {innerpacc_21, innerpacc_22}
              end
            else
              {innerpacc_21, innerpacc_22}
            end
          end)
        end)
      end)
    end)
  end

  def isCollinear(x, y, x1, y1, x2, y2) do
    (x - x1) * (y - y2) == (x - x2) * (y - y1)
  end

  def manhattanDistance(x1, y1, x2, y2) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  def constructMap(enum) do
    Enum.with_index(enum)
    |> Enum.reduce(%{}, fn {row, r}, outerMap ->
      row
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(outerMap, fn {char, c}, innerMap ->
        if char != "." do
          Map.update(innerMap, char, [{r, c}], fn existing -> [{r, c} | existing] end)
        else
          innerMap
        end
      end)
    end)
  end

  def tasks do
    File.read("../input")
    |> then(fn {_, string} -> String.trim(string) end)
    |> String.split("\n", trim: true)
    |> then(fn list ->
      rows = length(list)
      columns = String.length(Enum.at(list, 0))
      map = constructMap(list)

      Task.async_stream(
        0..(rows - 1),
        fn r ->
          processRow(r, rows, columns, map)
        end
      )
      |> Enum.reduce({0, 0}, fn {:ok, result}, {acc1, acc2} ->
        {result1, result2} = result
        {acc1 + MapSet.size(result1), acc2 + MapSet.size(result2)}
      end)
    end)
  end
end
