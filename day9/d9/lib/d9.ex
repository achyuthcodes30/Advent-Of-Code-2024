defmodule D9 do
  def setupDiskMap(string) do
    string
    # |> String.graphemes()
    # |> Enum.with_index()
    |> then(fn string ->
      for i <- 0..(String.length(string) - 1), reduce: {[], 0} do
        {newList, index} ->
          fileBlocks = String.to_integer(String.at(string, i))

          if rem(i, 2) == 0 do
            {[newList | List.duplicate(index, fileBlocks)], index + 1}
          else
            {[newList | List.duplicate(".", fileBlocks)], index}
          end
      end
    end)
    |> then(fn {list, _} ->
      List.flatten(list)
    end)
    |> then(fn list ->
      {swapBlocks(list, 0, length(list) - 1), swapFiles(list, 0, length(list) - 1)}
    end)
  end

  def swapFiles(list, left, right) when left < right do
    cond do
      Enum.at(list, left) != "." ->
        swapFiles(list, left + 1, right)

      Enum.at(list, right) == "." ->
        swapFiles(list, left, right - 1)

      true ->
        # maxSpaceIndex =
        #  Enum.reduce_while(Enum.slice(list, (left + 1)..right), left, fn x, index ->
        #   if x != ".", do: {:halt, index}, else: {:cont, index + 1}
        # end)

        minNumIndex =
          Enum.reduce_while(Enum.reverse(Enum.slice(list, left..(right - 1))), right, fn x,
                                                                                         index ->
            if x != Enum.at(list, right), do: {:halt, index}, else: {:cont, index - 1}
          end)

        {spaceSize, startSpaceIndex} =
          Enum.reduce_while(
            Enum.slice(Enum.with_index(list), (left + 1)..(right - 1)),
            {1, left},
            fn item, {size, startIndex} ->
              if size == right - minNumIndex + 1 do
                {:halt, {size, startIndex}}
              else
                {char, index} = item

                if char != "." do
                  {:cont, {0, index + 1}}
                else
                  {:cont, {size + 1, startIndex}}
                end
              end
            end
          )

        if(spaceSize < right - minNumIndex + 1) do
          swapFiles(list, left, minNumIndex - 1)
        else
          swapResult =
            Enum.reduce(0..(right - minNumIndex), list, fn i, newList ->
              newList
              |> List.replace_at(startSpaceIndex + i, Enum.at(list, right))
              |> List.replace_at(right - i, ".")
            end)

          swapFiles(swapResult, left, minNumIndex - 1)
        end
    end
  end

  def swapFiles(list, _left, _right) do
    list
  end

  def swapBlocks(list, left, right) when left < right do
    cond do
      Enum.at(list, left) != "." ->
        swapBlocks(list, left + 1, right)

      Enum.at(list, right) == "." ->
        swapBlocks(list, left, right - 1)

      true ->
        swapResult =
          list
          |> List.replace_at(left, Enum.at(list, right))
          |> List.replace_at(right, ".")

        swapBlocks(swapResult, left + 1, right - 1)
    end
  end

  def swapBlocks(list, _left, _right) do
    list
  end

  def tasks do
    File.read("../input")
    |> then(fn {_, string} ->
      String.trim(string)
    end)
    |> then(fn string ->
      setupDiskMap(string)
      |> then(fn {map1, map2} ->
        {map1, map2} = {Enum.with_index(map1), Enum.with_index(map2)}

        {map1
         |> Enum.reduce(0, fn {item, index}, sum ->
           if item != "." do
             sum + item * index
           else
             sum
           end
         end),
         map2
         |> Enum.reduce(0, fn {item, index}, sum ->
           if item != "." do
             sum + item * index
           else
             sum
           end
         end)}
      end)
    end)
  end
end
