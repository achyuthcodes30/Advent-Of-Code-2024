defmodule D4 do
  def easyIndex(enum, index1, index2) do
    String.at(Enum.at(enum, index1), index2)
  end

  def countXmas(matrix, r, c, rows, columns) do
    [
      c + 3 < columns and easyIndex(matrix, r, c) == "X" and easyIndex(matrix, r, c + 1) == "M" and
        easyIndex(matrix, r, c + 2) == "A" and easyIndex(matrix, r, c + 3) == "S",
      c + 3 < columns and easyIndex(matrix, r, c) == "S" and easyIndex(matrix, r, c + 1) == "A" and
        easyIndex(matrix, r, c + 2) == "M" and easyIndex(matrix, r, c + 3) == "X",
      r + 3 < rows and easyIndex(matrix, r, c) == "S" and easyIndex(matrix, r + 1, c) == "A" and
        easyIndex(matrix, r + 2, c) == "M" and easyIndex(matrix, r + 3, c) == "X",
      r + 3 < rows and easyIndex(matrix, r, c) == "X" and easyIndex(matrix, r + 1, c) == "M" and
        easyIndex(matrix, r + 2, c) == "A" and easyIndex(matrix, r + 3, c) == "S",
      r + 3 < rows and c + 3 < columns and easyIndex(matrix, r, c) == "X" and
        easyIndex(matrix, r + 1, c + 1) == "M" and
        easyIndex(matrix, r + 2, c + 2) == "A" and easyIndex(matrix, r + 3, c + 3) == "S",
      r + 3 < rows and c + 3 < columns and easyIndex(matrix, r, c) == "S" and
        easyIndex(matrix, r + 1, c + 1) == "A" and
        easyIndex(matrix, r + 2, c + 2) == "M" and easyIndex(matrix, r + 3, c + 3) == "X",
      r - 3 >= 0 and c + 3 < columns and easyIndex(matrix, r, c) == "S" and
        easyIndex(matrix, r - 1, c + 1) == "A" and
        easyIndex(matrix, r - 2, c + 2) == "M" and easyIndex(matrix, r - 3, c + 3) == "X",
      r - 3 >= 0 and c + 3 < columns and easyIndex(matrix, r, c) == "X" and
        easyIndex(matrix, r - 1, c + 1) == "M" and
        easyIndex(matrix, r - 2, c + 2) == "A" and easyIndex(matrix, r - 3, c + 3) == "S"
    ]
    |> Enum.count(& &1)
  end

  def countCrossMas(matrix, r, c, rows, columns) do
    [
      r + 2 < rows and c + 2 < columns and
        easyIndex(matrix, r, c) ==
          "M" and
        easyIndex(matrix, r + 1, c + 1) ==
          "A" and
        easyIndex(matrix, r + 2, c + 2) ==
          "S" and
        easyIndex(matrix, r, c + 2) == "M" and easyIndex(matrix, r + 2, c) == "S",
      r + 2 < rows and c + 2 < columns and
        easyIndex(matrix, r, c) ==
          "M" and
        easyIndex(matrix, r + 1, c + 1) ==
          "A" and
        easyIndex(matrix, r + 2, c + 2) ==
          "S" and
        easyIndex(matrix, r, c + 2) == "S" and easyIndex(matrix, r + 2, c) == "M",
      r + 2 < rows and c + 2 < columns and
        easyIndex(matrix, r, c) ==
          "S" and
        easyIndex(matrix, r + 1, c + 1) ==
          "A" and
        easyIndex(matrix, r + 2, c + 2) ==
          "M" and
        easyIndex(matrix, r, c + 2) == "M" and easyIndex(matrix, r + 2, c) == "S",
      r + 2 < rows and c + 2 < columns and
        easyIndex(matrix, r, c) ==
          "S" and
        easyIndex(matrix, r + 1, c + 1) ==
          "A" and
        easyIndex(matrix, r + 2, c + 2) ==
          "M" and
        easyIndex(matrix, r, c + 2) == "S" and easyIndex(matrix, r + 2, c) == "M"
    ]
    |> Enum.count(& &1)
  end

  def tasks do
    {_, string} =
      File.read("../input")

    matrix =
      string
      |> String.split("\n", trim: true)
      |> Enum.to_list()

    rows = length(matrix)
    columns = String.length(Enum.at(matrix, 0))

    count1 =
      Enum.reduce(0..(rows - 1), 0, fn r, acc ->
        Enum.reduce(0..(columns - 1), acc, fn c, inneracc ->
          inneracc + countXmas(matrix, r, c, rows, columns)
        end)
      end)

    count2 =
      Enum.reduce(0..(rows - 1), 0, fn r, acc ->
        Enum.reduce(0..(columns - 1), acc, fn c, inneracc ->
          inneracc + countCrossMas(matrix, r, c, rows, columns)
        end)
      end)

    {count1, count2}
  end
end
