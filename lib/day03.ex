defmodule Day03 do
  def part_1 do
    ~r/mul\((\d*),(\d*)\)/
      |> Regex.scan(input())
      |> Enum.map(fn [_, num1, num2] ->
        String.to_integer(num1) * String.to_integer(num2)
      end)
      |> Enum.sum()
  end

  def part_2 do
    {result, _} = input()
      |> Parser.parse()
      |> Enum.reduce({0, true}, fn element, {result, enabled?} ->
        case element do
          {x, y} ->
            if enabled? do
              {result + x * y, true}
            else
              {result, false}
            end

          "do" ->
            {result, true}

          "don't" ->
            {result, false}
        end
      end)

    result
  end

  def input do
    File.read!("inputs/day03.txt")
  end
end

defmodule Parser do
  # Define regex patterns
  @mul_regex ~r/mul\((\d+),(\d+)\)/
  @dont_regex ~r/don't\(\)/
  @do_regex ~r/do\(\)/

  def parse(stream), do: parse(stream, "", [])

  defp parse(<<>>, buffer, acc) do
    case match(buffer) do
      nil -> acc
      match -> [match | acc]
    end
      |> Enum.reverse()
  end

  defp parse(<<char::binary-size(1), rest::binary>>, buffer, acc) do
    new_buffer = buffer <> char

    case match(new_buffer) do
      nil ->
        parse(rest, new_buffer, acc)

      match ->
        parse(rest, "", [match | acc])
    end
  end

  defp match(buffer) do
    cond do
      Regex.match?(@mul_regex, buffer) ->
        [_, num1, num2] = Regex.run(@mul_regex, buffer)
        {String.to_integer(num1), String.to_integer(num2)}

      Regex.match?(@dont_regex, buffer) ->
        "don't"

      Regex.match?(@do_regex, buffer) ->
        "do"

      true ->
        nil # No match
    end
  end
end
