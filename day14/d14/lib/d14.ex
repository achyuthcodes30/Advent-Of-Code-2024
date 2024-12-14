defmodule D14 do
  def findTree(positionValues, t) when t < 100_000 do
    matrix = List.duplicate(List.duplicate(".", 101), 103)

    positionValues
    |> Enum.reduce({[], matrix}, fn row, {newPositionValues, accMatrix} ->
      {column, row, vc, vr} = {Enum.at(row, 0), Enum.at(row, 1), Enum.at(row, 2), Enum.at(row, 3)}
      newC = rem(column + vc, 101)
      newR = rem(row + vr, 103)

      newC = if newC < 0, do: newC + 101, else: newC
      newR = if newR < 0, do: newR + 103, else: newR

      newMatrix =
        accMatrix
        |> List.replace_at(newR, List.replace_at(Enum.at(accMatrix, newR), newC, "#"))

      {newPositionValues ++ [[newC, newR, vc, vr]], newMatrix}
    end)
    |> then(fn {positionVelocities, matrix} ->
      connected =
        Enum.reduce(0..102, 0, fn row, fullyConnected ->
          Enum.reduce(0..100, fullyConnected, fn column, innerFullyConnected ->
            robotNeighbours =
              [{1, 0}, {0, 1}, {-1, 0}, {0, -1}]
              |> Enum.reduce(0, fn {r, c}, neighbours ->
                nR = row + r
                nC = column + c

                if 0 <= nR and nR < 103 and 0 <= nC and nC < 101 and
                     matrix |> Enum.at(nR) |> Enum.at(nC) == "#",
                   do: neighbours + 1,
                   else: neighbours
              end)

            if robotNeighbours == 4, do: innerFullyConnected + 1, else: innerFullyConnected
          end)
        end)

      if connected >= 15 do
        IO.inspect(
          Enum.map(matrix, fn row ->
            Enum.join(row)
          end),
          limit: :infinity
        )

        IO.puts("Found tree at time #{t}")
        findTree(positionVelocities, t + 100_000)
      else
        findTree(positionVelocities, t + 1)
      end
    end)
  end

  def findTree(_positionValues, _t) do
    nil
  end

  def checkPos(column, row, vc, vr) do
    Enum.reduce(0..99, {column, row}, fn _, {accC, accR} ->
      newC = rem(accC + vc, 101)
      newR = rem(accR + vr, 103)

      newC = if newC < 0, do: newC + 101, else: newC
      newR = if newR < 0, do: newR + 103, else: newR

      {newC, newR}
    end)
    |> then(fn {c, r} ->
      cond do
        r == 51 and c == 50 ->
          {0, 0, 0, 0}

        r < 51 and c < 50 ->
          {1, 0, 0, 0}

        r < 51 and c > 50 ->
          {0, 1, 0, 0}

        r > 51 and c > 50 ->
          {0, 0, 0, 1}

        r > 51 and c < 50 ->
          {0, 0, 1, 0}

        true ->
          {0, 0, 0, 0}
      end
    end)
  end

  def tasks do
    File.read("../input")
    |> then(fn {_, string} ->
      String.trim(string)
      |> String.split("\n", trim: true)
      |> Enum.map(fn string ->
        Regex.scan(~r/-?\d+/, string)
        |> List.flatten()
        |> Enum.map(fn number ->
          String.to_integer(number)
        end)
      end)
    end)
    |> then(fn positionVelocities ->
      {positionVelocities
       |> Enum.reduce({0, 0, 0, 0}, fn list, {sum1, sum2, sum3, sum4} ->
         {column, row, vc, vr} =
           {Enum.at(list, 0), Enum.at(list, 1), Enum.at(list, 2), Enum.at(list, 3)}

         {newSum1, newSum2, newSum3, newSum4} = checkPos(column, row, vc, vr)
         {sum1 + newSum1, sum2 + newSum2, sum3 + newSum3, sum4 + newSum4}
       end)
       |> then(fn {s1, s2, s3, s4} ->
         s1 * s2 * s3 * s4
       end), findTree(positionVelocities, 1)}
    end)
  end
end
