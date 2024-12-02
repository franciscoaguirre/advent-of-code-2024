defmodule Day02 do
  def part_1 do
    parse()
      |> Enum.map(fn levels ->
          safe?(levels)
         end)
         |> Enum.filter(fn safe? ->
           safe?
         end)
         |> Enum.count()
  end

  def part_2 do
    parse()
      |> Enum.map(fn levels ->
          -1..length(levels)
            |> Enum.any?(fn index ->
              if index === -1 do
                safe?(levels)
              else
                new_levels = List.delete_at(levels, index)
                safe?(new_levels)
              end
         end)
      end)
      |> Enum.filter(fn safe? ->
        safe?
      end)
      |> Enum.count()
  end

  def safe?(levels) do
    {safety, _} = levels
      |> Enum.drop(1)
      |> Enum.zip(levels)
      |> Enum.reduce({true, :none}, fn {next, current}, {safe?, rate} ->
        if next > current && next <= current + 3 do
          {safe? && (rate === :increasing || rate === :none), :increasing}
        else
          if current > next && current <= next + 3 do
            {safe? && (rate === :decreasing || rate === :none), :decreasing}
          else
            {false, :none}
          end
        end
      end)
    safety
  end

  def parse do
    File.stream!("inputs/day02.txt")
      |> Enum.map(&String.trim/1)
      |> Enum.map(fn report ->
        String.split(report, " ")
          |> Enum.map(&String.to_integer/1)
      end)
  end
end
