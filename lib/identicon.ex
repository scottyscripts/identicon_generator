defmodule Identicon do
  @moduledoc """
  This module is used to convert any input string into an identicon image.
  """
  require Integer

  @doc """
  Takes an input string as an argument, converts it to an identicon image, and saves locally.
  """
  def main(input) do
    input
    |> hash_input_str
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  @doc """
  Hashes an input string using md5 algorithm.
  Converts new hash to list and saves to `%Identicon.Image` struct's `hex` field.
  """
  def hash_input_str(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end

  @doc """
  Determines and sets value for `color` field of `%Identicon.Image` struct.

  Uses first 3 values from list generated in `hash_input_str/1`
  """
  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end


  @doc """
  Creates list of tuples representing 5x5 grid using `%Identicon.Image`'s' `hex` value.

  Each tuple consists of the original hex value and its index.

  Indices map to resulting grid as follows
      [ 0,  1,  2,  3,  4
        5,  6,  7,  8,  9,
        10, 11, 12, 13, 14 ]

  """
  def build_grid(%Identicon.Image{hex: hex_list} = image) do
    grid =
      hex_list
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.with_index

    %Identicon.Image{image | grid: grid}
  end

  @doc """
  Takes a list of 3 values and mirrors them to create a list w/ 5 values

  ## Examples

      iex> list = [455, 287, 343]
      iex> Identicon.mirror_row(list)
      [455, 287, 343, 287, 455]

  """
  def mirror_row([first, second | _tail] = row) do
    row ++ [second, first]
  end

  @doc """
  Removes all tuples from list stored in `%Identicon.Image` grid.

  Keeps tuples containing even hex values, since these will be colored in final identicon.
  """
  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    filtered_grid =
      grid
      |> Enum.filter(fn({code, _index}) ->
        Integer.is_even(code)
      end)

    %Identicon.Image{image | grid: filtered_grid}
  end

  @doc """
  Generates pixel_map on `%Identicon.Image`.

  pixel_map is a list of tuples containing start (top left) and stop (bottom right)
  coordinates when drawing colors on identicon image.
  """
  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map =
      grid
      |> Enum.map(fn({_code, index}) ->
        horizontal_origin = rem(index, 5) * 50
        vertical_origin = div(index, 5) * 50

        top_left = {horizontal_origin, vertical_origin}
        bottom_right = {horizontal_origin + 50, vertical_origin + 50}

        {top_left, bottom_right}
      end)

      %Identicon.Image{image | pixel_map: pixel_map}
  end

  @doc """
  Uses erlang's :egd (erlang graphical drawer) to create an image and color in values
  determined by `build_pixel_map/1`
  """
  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    pixel_map
    |> Enum.each(fn({top_left, bottom_right}) ->
      :egd.filledRectangle(
        image,
        top_left,
        bottom_right,
        fill
      )
      end)

    :egd.render(image)
  end

  @doc """
  Saves newly generated identicon locally.

  File name determined by original input string passed to `main/1`
  """
  def save_image(image, input) do
    File.write("images/#{input}.png", image)
  end

end
