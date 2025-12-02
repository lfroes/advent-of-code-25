defmodule Input do
  @doc """
  Reads the input file for the given day.

      iex> Input.read("day011.txt")
  """

  def read(filename) do
    Path.join(:code.priv_dir(:advent_of_code), "#{filename}")
    |> File.read!()
  end

  def lines(text) do
    String.split(text, "\n", trim: true)
  end
end
