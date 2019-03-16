defmodule Identicon do
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
  end

  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  def build_grid(%Identicon.Image{hex: hex_list} = image) do
    hex_list
    |> Enum.chunk_every(3, 3, :discard)
    |> Enum.map(&mirror_row/1)
  end

  def mirror_row([first, second | _tail] = row) do
    row ++ [second, first]
  end

  @doc """
  generates `Identicon.Image` struct created from list of bytes

  `input` is a string that gets hashed using md5 algorithm
  """
  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end
end
