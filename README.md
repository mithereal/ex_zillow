# Zillow

[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/zillow/)
[![Hex.pm](https://img.shields.io/hexpm/dt/zillow.svg)](https://hex.pm/packages/zillow)
[![License](https://img.shields.io/hexpm/l/zillow.svg)](https://github.com/mithereal/ex_zillow/blob/master/LICENSE)
[![Last Updated](https://img.shields.io/github/last-commit/mithereal/ex_zillow.svg)](https://github.com/mithereal/ex_zillow/commits/master)

** This will fetch Information From Zillow about a given address **

## Installation

[available in Hex](https://hex.pm/packages/zillow), the package can be installed by adding `zillow` to your list of
dependencies in `mix.exs`:

```elixir
def deps do
  [{:zillow, "~> 2.1.0"}]
end
```

## Config

```elixir
config :zillow, api_key: "zillow-key"
```

## Usage

```elixir
iex > address = "4406 N 48th st"

iex > area = "Phoenix, AZ 85008"

iex > address_record = %{address: address, area: area}

iex > Zillow.fetch(address_record)
%{error: 2, message: "invalid zillow api key"}
```
