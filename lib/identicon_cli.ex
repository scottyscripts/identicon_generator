defmodule Identicon.CLI do
  def main([]) do
    IO.puts("Please provide the string you would like to generate identicon for as first argument.")
  end

  def main([input | _other_args]) do
    IO.puts("Generating identicon for \"#{input}\"")
    Identicon.main(input)
  end

end
