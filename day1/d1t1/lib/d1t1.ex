defmodule D1t1 do
  def tasks do
    {team1, team2} =
      File.stream!("../input")
      |> Stream.map(&String.trim/1)
      |> Stream.map(&String.split(&1, ~r/\s+/))
      |> Enum.reduce({[], []}, fn line, {acc1, acc2} ->
        [point1, point2] = line
        {[point1 | acc1], [point2 | acc2]}
      end)

    team1 = Enum.sort(team1)
    team2 = Enum.sort(team2)

    sum =
      Enum.zip(team1, team2)
      |> Enum.reduce(0, fn {a, b}, acc ->
        {item1, _} = Integer.parse(a)
        {item2, _} = Integer.parse(b)
        acc + abs(item1 - item2)
      end)

    IO.puts(sum)

    frequencies =
      Enum.frequencies_by(team2, fn item ->
        {number, _} = Integer.parse(item)
        number
      end)

    simScore =
      Enum.reduce(team1, 0, fn item, acc ->
        {number, _} = Integer.parse(item)

        acc + number * Map.get(frequencies, number, 0)
      end)

    IO.puts(simScore)
  end
end
