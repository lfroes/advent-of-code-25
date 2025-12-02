defmodule AdventOfCode do
  @moduledoc """
  Documentation for `AdventOfCode`.
  """

  def run(day), do: apply(:"Elixir.Day#{day}", :run, [])
end
