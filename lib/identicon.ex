defmodule Identicon do
  def main(input) do
    input
    |> hash_input
  end

  @doc """
  generates list of bytes by creating hash value from string using md5 algorithm
  """
  def hash_input(input) do
    :crypto.hash(:md5, input)
    |> :binary.bin_to_list
  end
end
