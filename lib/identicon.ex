defmodule Identicon do
  require Integer
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  def build_grid(%Identicon.Image{hex: hex_list} = image) do
    grid =
      hex_list
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.with_index

    %Identicon.Image{image | grid: grid}
  end

  def mirror_row([first, second | _tail] = row) do
    row ++ [second, first]
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    filtered_grid =
      grid
      |> Enum.filter(fn({code, _index}) ->
        Integer.is_even(code)
      end)

    %Identicon.Image{image | grid: filtered_grid}
  end

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

  def save_image(image, input) do
    File.write("#{input}.png", image)
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
