defmodule D5 do
  def kvSet(map, key, value) do
    {key, value} = {String.to_integer(key), String.to_integer(value)}

    Map.update(map, key, [value], fn values ->
      values ++ [value]
    end)
  end

  def checkUpdate(map, list) do
    reversedList = Enum.reverse(list)

    reversedList
    |> Enum.any?(fn outerElement ->
      Enum.any?(
        Enum.slice(
          reversedList,
          (Enum.find_index(reversedList, fn x -> x == outerElement end) + 1)..-1//1
        ),
        fn innerElement ->
          innerElement in Map.get(map, outerElement)
        end
      )
    end)
  end

  def getMiddle(list) do
    element = Enum.at(list, div(length(list) - 1, 2))

    if element != nil do
      String.to_integer(element)
    else
      0
    end

    # String.to_integer(Enum.at(list, div(length(list) - 1, 2)))
  end

  def processLine(line) do
    if String.contains?(line, "|") do
      String.split(line, "|", trim: true)
    else
      String.split(line, ",", trim: true)
    end
  end

  def tasks do
    File.stream!("../input")
    |> Stream.chunk_by(&(&1 == ""))
    |> Stream.reject(&Enum.empty?(&1))
    |> Enum.to_list()
    |> List.flatten()
    |> Enum.map(&String.trim/1)
    |> Enum.map(&processLine/1)
    |> Enum.reduce({%{}, 0, 0}, fn processedLine, {accMap, t1sum, t2sum} ->
      if Enum.count(processedLine) == 2 do
        {key, value} = {Enum.at(processedLine, 0), Enum.at(processedLine, 1)}

        {Map.update(accMap, key, [value], fn values ->
           values ++ [value]
         end), t1sum, t2sum}
      else
        if not checkUpdate(accMap, processedLine) do
          if getMiddle(processedLine) != nil do
            {accMap, t1sum + getMiddle(processedLine), t2sum}
          else
            {accMap, t1sum, t2sum}
          end
        else
          sum =
            getMiddle(
              Enum.sort(processedLine, fn a, b ->
                if b in Map.get(accMap, a) do
                  true
                else
                  false
                end
              end)
            )

          {accMap, t1sum, t2sum + sum}
        end
      end
    end)
  end
end
