defmodule Day01 do
  def part_1 do
    parse()
      |> then(fn {list1, list2} ->
        Enum.zip(list1, list2)
      end)
      |> Enum.map(fn {item1, item2} ->
        abs(item2 - item1)
      end)
      |> Enum.sum()
  end

  def part_2 do
    parse()
      |> then(fn {list1, list2} ->
        frequencies = Enum.frequencies(list2)
        list1
          |> Enum.map(fn element ->
            frequency = Map.get(frequencies, element, 0)
            element * frequency
          end)
          |> Enum.sum()
      end)
  end

  def parse do
    File.stream!("inputs/day01.txt")
      |> Enum.map(&String.trim/1)
      |> Enum.reduce({[], []}, fn line, {list1, list2} ->
        [item1, item2] = String.split(line, "   ")
          |> Enum.map(&String.to_integer/1)
        {[item1 | list1], [item2 | list2]}
      end)
      |> then(fn {list1, list2} ->
        {Enum.sort(list1), Enum.sort(list2)}
      end)
  end
end
