defmodule D11 do
  def count(x, steps, memo \\ %{}) do
    case Map.get(memo, {x, steps}) do
      nil ->
        {result, updated_memo} =
          cond do
            steps == 0 ->
              {1, memo}

            x == 0 ->
              count(1, steps - 1, memo)

            rem(String.length(Integer.to_string(x)), 2) == 0 ->
              string_x = Integer.to_string(x)
              {a, b} = String.split_at(string_x, div(String.length(string_x), 2))

              b = if String.to_integer(b) == 0, do: 0, else: String.to_integer(b)

              {res1, memo1} = count(String.to_integer(a), steps - 1, memo)
              {res2, memo2} = count(b, steps - 1, memo1)
              {res1 + res2, memo2}

            true ->
              count(x * 2024, steps - 1, memo)
          end

        updated_memo = Map.put(updated_memo, {x, steps}, result)
        {result, updated_memo}

      memoized_result ->
        {memoized_result, memo}
    end
  end

  def tasks do
    File.read("../input")
    |> then(fn {_, string} ->
      String.trim(string)
      |> String.split(" ", trim: true)
      |> Enum.map(fn x -> String.to_integer(x) end)
    end)
    |> then(fn list ->
      {list
       |> Task.async_stream(
         fn x ->
           count(x, 25)
         end,
         max_concurrency: System.schedulers_online(),
         timeout: :infinity
       )
       |> Enum.reduce(0, fn {:ok, result}, sum ->
         {summer, _} = result
         sum + summer
       end),
       list
       |> Task.async_stream(
         fn x ->
           count(x, 75)
         end,
         max_concurrency: System.schedulers_online(),
         timeout: :infinity
       )
       |> Enum.reduce(0, fn {:ok, result}, sum ->
         {summer, _} = result
         sum + summer
       end)}
    end)
  end
end
