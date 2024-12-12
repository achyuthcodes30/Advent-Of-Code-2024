defmodule D12 do
  def areaPerim(matrix, rows, columns, queue, seen, area, perimeter, perimeterMap)
      when length(queue) > 0 do
    {{r, c}, newQueue} = List.pop_at(queue, 0)

    cond do
      {r, c} in seen ->
        areaPerim(matrix, rows, columns, newQueue, seen, area, perimeter, perimeterMap)

      true ->
        newSeen = MapSet.put(seen, {r, c})
        newArea = area + 1
        directions = [{0, -1}, {-1, 0}, {0, 1}, {1, 0}]

        {finalQueue, newPerimeter, newPerimeterMap} =
          Enum.reduce(directions, {newQueue, perimeter, perimeterMap}, fn {x, y},
                                                                          {accQueue, accPerimeter,
                                                                           accPerimeterMap} ->
            newR = r + x
            newC = c + y

            if 0 <= newR and newR < rows and 0 <= newC and newC < columns and
                 easyIndex(matrix, r, c) == easyIndex(matrix, newR, newC) do
              {accQueue ++ [{newR, newC}], accPerimeter, accPerimeterMap}
            else
              accPerimeterMap =
                Map.update(accPerimeterMap, {x, y}, MapSet.new([{r, c}]), fn existing ->
                  MapSet.put(existing, {r, c})
                end)

              {accQueue, accPerimeter + 1, accPerimeterMap}
            end
          end)

        areaPerim(
          matrix,
          rows,
          columns,
          finalQueue,
          newSeen,
          newArea,
          newPerimeter,
          newPerimeterMap
        )
    end
  end

  def areaPerim(_matrix, _rows, _columns, _queue, seen, area, perimeter, perimeterMap) do
    {seen, area, perimeter, perimeterMap}
  end

  def findSides(values, sides) do
    Enum.reduce(values, {sides, MapSet.new()}, fn {x, y}, {innerSides, innerAccSeen} ->
      if {x, y} not in innerAccSeen do
        connectedSet = bfsSides([{x, y}], innerAccSeen, values)
        {innerSides + 1, MapSet.union(innerAccSeen, connectedSet)}
      else
        {innerSides, innerAccSeen}
      end
    end)
  end

  def bfsSides(queue, seen, values) when length(queue) > 0 do
    {{r, c}, newQueue} = List.pop_at(queue, 0)

    cond do
      {r, c} in seen ->
        bfsSides(newQueue, seen, values)

      true ->
        newSeen = MapSet.put(seen, {r, c})
        directions = [{0, -1}, {-1, 0}, {0, 1}, {1, 0}]

        updatedQueue =
          Enum.reduce(directions, newQueue, fn {x, y}, accQueue ->
            newR = r + x
            newC = c + y

            if {newR, newC} in values do
              accQueue ++ [{newR, newC}]
            else
              accQueue
            end
          end)

        bfsSides(updatedQueue, newSeen, values)
    end
  end

  def bfsSides(_queue, seen, _values) do
    seen
  end

  def easyIndex(matrix, r, c) do
    String.at(Enum.at(matrix, r), c)
  end

  def tasks do
    File.read!("../input")
    |> String.trim()
    |> String.split("\n", trim: true)
    |> then(fn matrix ->
      rows = length(matrix)
      columns = String.length(Enum.at(matrix, 0))

      Enum.reduce(0..(rows - 1), {MapSet.new(), 0, 0}, fn row, {seen, p1, p2} ->
        Enum.reduce(0..(columns - 1), {seen, p1, p2}, fn col, {innerSeen, innerP1, innerP2} ->
          if {row, col} in innerSeen do
            {innerSeen, innerP1, innerP2}
          else
            {newSeen, newArea, newPerimeter, newPerimeterMap} =
              areaPerim(matrix, rows, columns, [{row, col}], innerSeen, 0, 0, %{})

            sides =
              Enum.reduce(newPerimeterMap, 0, fn {_, values}, accSides ->
                {newSides, _} = findSides(values, accSides)
                newSides
              end)

            {newSeen, innerP1 + newArea * newPerimeter, innerP2 + newArea * sides}
          end
        end)
      end)
    end)
    |> then(fn {_, p1, p2} ->
      {p1, p2}
    end)
  end
end
