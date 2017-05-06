defmodule Phone do
  @invalid "0000000000"
  @doc """
  Remove formatting from a phone number.

  Returns "0000000000" if phone number is not valid
  (10 digits or "1" followed by 10 digits)

  ## Examples

  iex> Phone.number("123-456-7890")
  "1234567890"

  iex> Phone.number("+1 (303) 555-1212")
  "3035551212"

  iex> Phone.number("867.5309")
  "0000000000"
  """
  @spec number(String.t) :: String.t
  def number(raw) do
    raw
    |> String.replace(~r/[\s.()-]/, "") # remove reading helpers
    |> valid?
    |> (fn false -> @invalid; num -> String.replace(num, ~r/^1/, "") end).()
  end

  def valid?(num) do
    Regex.match?(~r/^1?(?:[2-9][0-9]{2}){2}\d{4}$/, num)
    |> (fn true -> num; false -> false end).()
  end

  @doc """
  Extract the area code from a phone number

  Returns the first three digits from a phone number,
  ignoring long distance indicator

  ## Examples

  iex> Phone.area_code("123-456-7890")
  "123"

  iex> Phone.area_code("+1 (303) 555-1212")
  "303"

  iex> Phone.area_code("867.5309")
  "000"
  """
  @spec area_code(String.t) :: String.t
  def area_code(raw) do         
    raw
    |> __MODULE__.number
    |> String.slice(0, 3)      # the first three numbers are area_code
  end

  @doc """
  Pretty print a phone number

  Wraps the area code in parentheses and separates
  exchange and subscriber number with a dash.

  ## Examples

  iex> Phone.pretty("123-456-7890")
  "(123) 456-7890"

  iex> Phone.pretty("+1 (303) 555-1212")
  "(303) 555-1212"

  iex> Phone.pretty("867.5309")
  "(000) 000-0000"
  """
  @spec pretty(String.t) :: String.t
  def pretty(raw) do
    raw
    |> __MODULE__.number
    |> (fn <<area_code::binary-size(3), exchange_code::binary-size(3), rest::binary>> ->
      "(" <> area_code <> ") " <> exchange_code <> "-" <> rest
    end).()
  end
end
