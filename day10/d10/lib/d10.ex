defmodule D10 do
  def allScores(matrix, queue, rows, columns, seen, ans, task) when length(queue) > 0 do
    {{r, c}, newQueue} = List.pop_at(queue, 0)

    cond do
      {r, c} in seen and task == "task1" ->
        allScores(matrix, newQueue, rows, columns, seen, ans, task)

      true ->
        newSeen = MapSet.put(seen, {r, c})

        ans = if easyIndex(matrix, r, c) == "9", do: ans + 1, else: ans

        newQueue =
          [{0, 1}, {1, 0}, {0, -1}, {-1, 0}]
          |> Enum.reduce(newQueue, fn {x, y}, acc ->
            rr = r + x
            cc = c + y

            if 0 <= rr and rr < rows and 0 <= cc and cc < columns and
                 String.to_integer(easyIndex(matrix, rr, cc)) ==
                   String.to_integer(easyIndex(matrix, r, c)) + 1 do
              acc ++ [{rr, cc}]
            else
              acc
            end
          end)

        allScores(matrix, newQueue, rows, columns, newSeen, ans, task)
    end
  end

  def allScores(_matrix, _queue, _rows, _columns, _seen, ans, _task), do: ans

  def easyIndex(matrix, x, y) do
    String.at(Enum.at(matrix, x), y)
  end

  def tasks do
    File.read("../input")
    |> then(fn {_, string} -> String.trim(string) end)
    |> String.split("\n", trim: true)
    |> then(fn list ->
      rows = length(list)
      columns = String.length(Enum.at(list, 0))

      Enum.reduce(
        0..(rows - 1),
        {0, 0},
        fn i, {t1, t2} ->
          Enum.reduce(0..(columns - 1), {t1, t2}, fn j, {acct1, acct2} ->
            if easyIndex(list, i, j) == "0" do
              {acct1 + allScores(list, [{i, j}], rows, columns, MapSet.new(), 0, "task1"),
               acct2 + allScores(list, [{i, j}], rows, columns, MapSet.new(), 0, "task2")}
            else
              {acct1, acct2}
            end
          end)
        end
      )
    end)
  end
end
