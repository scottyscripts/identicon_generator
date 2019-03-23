# Identicon Generator

![Identicon](https://user-images.githubusercontent.com/13722245/54872077-d7a62800-4d94-11e9-9775-5424fd38eb60.png)

This Elixir application generates 5x5 (identicon)[https://en.wikipedia.org/wiki/Identicon] images for a given string.

The basis for this app is from Udemy course (The Complete Elixir and Phoenix Bootcamp)[https://www.udemy.com/the-complete-elixir-and-phoenix-bootcamp-and-tutorial/].

I have made some small changes and have enabled running this app from the CLI via `escript`.

## Setting Up

1. Clone this repostitory locally and `cd` into the newly created directory
2. Run `mix deps.get`
3. (Optional) Run `mix docs` to generate documentation for this application.

## Generate Your Own Identicons!

To generate identicons, run the following in your terminal while in the main directory of this project.
```bash
./identicon some_string
```

`some_string` is whatever combination of characters you would like to generate identicon for!

You can find your newly generated identicon in the `images/` directory at `./images/<some_string>.png`.
