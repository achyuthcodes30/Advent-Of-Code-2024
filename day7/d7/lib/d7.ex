defmodule D7 do
  def goodTarget(target, numbers, task) do
    cond do
      length(numbers) == 1 ->
        hd(numbers) == target

      goodTarget(
        target,
        [
          Enum.at(numbers, 0) + Enum.at(numbers, 1)
          | Enum.slice(numbers, 2..-1//1)
        ],
        task
      ) ->
        true

      goodTarget(
        target,
        [
          Enum.at(numbers, 0) * Enum.at(numbers, 1)
          | Enum.slice(numbers, 2..-1//1)
        ],
        task
      ) ->
        true

      task and
          goodTarget(
            target,
            [
              String.to_integer(
                Integer.to_string(Enum.at(numbers, 0)) <> Integer.to_string(Enum.at(numbers, 1))
              )
              | Enum.slice(numbers, 2..-1//1)
            ],
            task
          ) ->
        true

      true ->
        false
    end
  end

  def tasks do
    File.stream!("../input")
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, ":"))
    |> Stream.map(fn [testValue, numbers] ->
      {String.to_integer(String.trim(testValue)),
       String.split(String.trim(numbers))
       |> Enum.map(fn x ->
         String.to_integer(x)
       end)}
    end)
    |> then(fn result ->
      Enum.to_list(result)
    end)
    |> Task.async_stream(
      fn {target, numbers} ->
        cond do
          goodTarget(target, numbers, false) ->
            {:first, target, target}

          goodTarget(target, numbers, true) ->
            {:second, 0, target}

          true ->
            {:none, 0, 0}
        end
      end,
      max_concurrency: System.schedulers_online() * 8
    )
    |> Enum.reduce({0, 0}, fn {:ok, {_, t1_inc, t2_inc}}, {t1, t2} ->
      {t1 + t1_inc, t2 + t2_inc}
    end)
  end
end
