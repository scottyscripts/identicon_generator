defmodule Identicon do
  def main(input) do
    input
    |> hash_input
    |> pick_color
  end

  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]}) do
    [r, g, b]
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
