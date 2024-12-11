defmodule D6 do
  def checkCycle(matrix, x, y, d, vertexX, vertexY, seen, putInSeen) do
    rows = length(matrix)
    columns = String.length(Enum.at(matrix, 0))

    if {x, y, d} in seen do
      true
    else
      seen =
        if putInSeen do
          [{x, y, d} | seen]
        else
          seen
        end

      directions = [{-1, 0}, {0, 1}, {1, 0}, {0, -1}]
      {dr, dc} = Enum.at(directions, d)
      newR = x + dr
      newC = y + dc

      if newR < 0 or newR >= rows or newC < 0 or newC >= columns do
        false
      else
        if easyIndex(matrix, newR, newC) == "#" or (newR == vertexX and newC == vertexY) do
          checkCycle(matrix, x, y, rem(d + 1, 4), vertexX, vertexY, seen, true)
        else
          checkCycle(matrix, newR, newC, d, vertexX, vertexY, seen, false)
        end
      end
    end
  end

  def traversed(matrix, x, y, d, seen) do
    rows = length(matrix)
    columns = String.length(Enum.at(matrix, 0))

    seen =
      if {x, y} not in seen do
        [{x, y} | seen]
      else
        seen
      end

    directions = [{-1, 0}, {0, 1}, {1, 0}, {0, -1}]
    {dr, dc} = Enum.at(directions, d)
    newR = x + dr
    newC = y + dc

    if newR < 0 or newR >= rows or newC < 0 or newC >= columns do
      seen
    else
      if easyIndex(matrix, newR, newC) == "#" do
        traversed(matrix, x, y, rem(d + 1, 4), seen)
      else
        traversed(matrix, newR, newC, d, seen)
      end
    end
  end

  def easyIndex(enum, index1, index2) do
    String.at(Enum.at(enum, index1), index2)
  end

  def tasks do
    matrix =
      File.stream!("../input")
      |> Stream.map(&String.trim/1)
      |> Enum.to_list()

    rows = length(matrix)
    columns = String.length(Enum.at(matrix, 0))

    {time, result} =
      :timer.tc(fn ->
        Enum.find_value(0..(rows - 1), fn i ->
          Enum.find_value(0..(columns - 1), fn j ->
            if easyIndex(matrix, i, j) == "^" do
              {i, j}
            else
              nil
            end
          end)
        end)
        |> then(fn {x, y} ->
          traversal = traversed(matrix, x, y, 0, [])
          IO.puts(length(traversal))

          traversal
          |> Task.async_stream(
            fn {vertexX, vertexY} ->
              if checkCycle(matrix, x, y, 0, vertexX, vertexY, [], false) do
                1
              else
                0
              end
            end,
            max_concurrency: System.schedulers_online() * 12
          )
          |> Enum.reduce(0, fn {:ok, result}, acc -> acc + result end)
        end)
      end)

    IO.puts("Task execution time for t2: #{time / 1_000_000} seconds")
    result
  end
end
