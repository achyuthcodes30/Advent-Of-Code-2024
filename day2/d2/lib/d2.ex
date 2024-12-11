defmodule D2 do
  def isSafe(list) do
    inc_or_dec = list == Enum.sort(list) or list == Enum.sort(list, &(&1 >= &2))

    safe =
      list
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.all?(fn [x, y] ->
        abs(x - y) in 1..3
      end)

    safe and inc_or_dec
  end

  def tasks do
    File.stream!("../input")
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split/1)
    |> Enum.map(fn list ->
      Enum.map(list, &String.to_integer/1)
    end)
    |> then(fn lines ->
      t1 =
        lines
        |> Enum.count(fn list ->
          isSafe(list)
        end)

      t2 =
        lines
        |> Enum.count(fn list ->
          list |> Enum.to_list()

          Enum.any?(0..(length(list) - 1), fn i ->
            newList = List.delete_at(list, i)
            isSafe(newList)
          end)
        end)

      {t1, t2}
    end)
  end
end
