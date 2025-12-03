defmodule AdventOfCode.Day02 do
  @moduledoc """
  Documentation for `AdventOfCode.Day02`.
  """

  def run do
    input =
      "day02.txt"
      |> Input.read()
      |> Input.lines()
      |> parse_instructions()

    part1 = solve_part1(input)
    part2 = solve_part2(input)

    IO.inspect(part1, label: "Day 2 / Part 1")
    IO.inspect(part2, label: "Day 2 / Part 2")
  end

  defp parse_instructions([line]) do
    line
    |> String.split(",", trim: true)
    |> Enum.map(fn range ->
      [start_str, end_str] = String.split(range, "-")
      {String.to_integer(start_str), String.to_integer(end_str)}
    end)
  end

  defp solve_part1(instructions) do
    Enum.reduce(instructions, 0, fn {start, finish}, acc_total ->
      range_sum = get_invalid_ids(start, finish)
      acc_total + range_sum
    end)
  end

  defp get_invalid_ids(start, finish) do
    Enum.reduce(start..finish, 0, fn id, acc ->
      if is_invalid_id(id) do
        acc + id
      else
        acc
      end
    end)
  end

  defp is_invalid_id(id) do
    s = Integer.to_string(id)
    len = String.length(s)

    if Integer.mod(len, 2) == 1 do
      false
    else
      half = div(len, 2)
      start = binary_part(s, 0, half)
      end_ = binary_part(s, half, half)

      if start == end_ do
        true
      else
        false
      end
    end
  end

  defp solve_part2(instructions) do
    instructions
    |> Enum.reduce(0, fn {start, finish}, acc_total ->
      range_sum = get_invalid_ids_2(start, finish)
      acc_total + range_sum
    end)
  end

  defp get_invalid_ids_2(start, finish) do
    Enum.reduce(start..finish, 0, fn id, acc ->
      if is_invalid_id_2(id) do
        acc + id
      else
        acc
      end
    end)
  end

  defp is_invalid_id_2(id) do
    s = Integer.to_string(id)
    len = String.length(s)

    if len < 2 do
      false
    else
      max_m = div(len, 2)

      1..max_m
      |> Enum.any?(fn m ->
        if rem(len, m) != 0 do
          false
        else
          pattern = binary_part(s, 0, m)
          repeats = div(len, m)

          Enum.all?(0..(repeats - 1), fn i ->
            binary_part(s, i * m, m) == pattern
          end)
        end
      end)
    end
  end
end
