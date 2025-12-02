defmodule AdventOfCode.Day01 do
  @moduledoc """
  Documentation for `AdventOfCode.Day01`.
  """

  @ring_size 100
  @start_position 50

  def run do
    input =
      "day011.txt"
      |> Input.read()
      |> Input.lines()
      |> parse_instructions()

    part1 = solve_part1(input)
    part2 = solve_part2(input)

    IO.inspect(part1, label: "Day 1 / Part 1")
    IO.inspect(part2, label: "Day 1 / Part 2")
  end

  defp parse_instructions(lines) do
    Enum.map(lines, fn <<dir::binary-size(1), dist::binary>> ->
      {String.to_atom(dir), String.to_integer(dist)}
    end)
  end

  defp solve_part1(instructions) do
    {dial, _position} =
      Enum.reduce(instructions, {0, 50}, fn instruction, state ->
        apply_instruction(state, instruction)
      end)

    dial
  end

  defp apply_instruction({dial, position}, {:L, steps}) do
    new_position =
      position
      |> Kernel.-(steps)
      |> Integer.mod(100)

    new_dial =
      if new_position == 0 do
        dial + 1
      else
        dial
      end

    {new_dial, new_position}
  end

  defp apply_instruction({dial, position}, {:R, steps}) do
    new_position =
      position
      |> Kernel.+(steps)
      |> Integer.mod(100)

    new_dial =
      if new_position == 0 do
        dial + 1
      else
        dial
      end

    {new_dial, new_position}
  end

  # PART 2

  defp solve_part2(instructions) do
    {dial, _position} =
      Enum.reduce(instructions, {0, @start_position}, fn instruction, state ->
        apply_instruction_part2(state, instruction)
      end)

    dial
  end

  defp apply_instruction_part2({dial, position}, {:R, steps}) do
    passes = zero_passes(position, :R, steps)

    new_position =
      position
      |> Kernel.+(steps)
      |> Integer.mod(@ring_size)

    {dial + passes, new_position}
  end

  defp apply_instruction_part2({dial, position}, {:L, steps}) do
    passes = zero_passes(position, :L, steps)

    new_position =
      position
      |> Kernel.-(steps)
      |> Integer.mod(@ring_size)

    {dial + passes, new_position}
  end

  defp zero_passes(start, :R, steps) do
    base = div(steps, @ring_size)
    leftover = rem(steps, @ring_size)

    cross =
      if leftover >= @ring_size - start and start != 0 do
        1
      else
        0
      end

    base + cross
  end

  defp zero_passes(start, :L, steps) do
    base = div(steps, @ring_size)
    leftover = rem(steps, @ring_size)

    cross =
      if start == 0 do
        0
      else
        if leftover >= start, do: 1, else: 0
      end

    base + cross
  end
end
