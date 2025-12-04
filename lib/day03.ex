defmodule AdventOfCode.Day03 do
  @moduledoc """
  Documentation for `AdventOfCode.Day03`.
  """

  def run do
    input =
      "day03.txt"
      |> Input.read()
      |> Input.lines()

    part1 = solve_part1(input)
    part2 = solve_part2(input)

    IO.inspect(part1, label: "Day 3 / Part 1")
    IO.inspect(part2, label: "Day 3 / Part 2")
  end

  defp solve_part1(lines) do
    Enum.reduce(lines, 0, fn line, acc ->
      digits = String.codepoints(line) |> Enum.map(&String.to_integer/1)
      acc + max_jolts(digits)
    end)
  end

  defp max_jolts(digits) do
    len = length(digits)

    initial_state = {0, Enum.at(digits, len - 1)}

    {best_value, _max_right} =
      Enum.reduce(Range.new(len - 2, 0, -1), initial_state, fn i, {best, max_right} ->
        left = Enum.at(digits, i)
        candidate = left * 10 + max_right

        new_best = if candidate > best, do: candidate, else: best
        new_max_right = if left > max_right, do: left, else: max_right

        {new_best, new_max_right}
      end)

    best_value
  end

  defp solve_part2(lines) do
    Enum.reduce(lines, 0, fn line, acc ->
      digits = String.codepoints(line) |> Enum.map(&String.to_integer/1)
      acc + max_jolts_2(digits)
    end)
  end

  defp max_jolts_2(digits) do
    k = 12
    n = length(digits)
    to_remove = n - k

    {stack, to_remove_left} =
      Enum.reduce(digits, {[], to_remove}, fn d, {stack, to_remove} ->
        {stack_after_pops, to_remove_left} = pop_smaller(stack, d, to_remove)
        {[d | stack_after_pops], to_remove_left}
      end)

    trimmed_stack =
      if to_remove_left > 0 do
        Enum.drop(stack, to_remove_left)
      else
        stack
      end

    trimmed_stack
    |> Enum.reverse()
    |> Enum.take(k)
    |> digits_to_int()
  end

  defp pop_smaller(stack, _d, 0), do: {stack, 0}
  defp pop_smaller([], _d, to_remove), do: {[], to_remove}

  defp pop_smaller([top | rest] = stack, d, to_remove) do
    if to_remove > 0 and top < d do
      pop_smaller(rest, d, to_remove - 1)
    else
      {stack, to_remove}
    end
  end

  defp digits_to_int(digits) do
    Enum.reduce(digits, 0, fn d, acc -> acc * 10 + d end)
  end
end
