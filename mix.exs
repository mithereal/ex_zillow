defmodule Zillow.MixProject do
  use Mix.Project

  @version "2.1.0"
  @source_url "https://github.com/mithereal/ex_zillow.git"

  def project do
    [
      app: :zillow,
      version: @version,
      elixir: "~> 1.9",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      description: description(),
      name: "Zillow Api",
      source_url: @source_url,
      package: package()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp applications(:test), do: [:logger]
  defp applications(_), do: [:logger]

  defp elixirc_paths(:test), do: ["lib", "test"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:tesla, "~> 1.4"},
      {:hackney, "~> 1.17"},
      {:friendly, "~> 1.1"},
      {:ex_doc, ">= 0.19.1", only: :dev, runtime: false},
      {:inch_ex, ">= 0.0.0", only: :docs}
    ]
  end

  defp description() do
    """
    This will fetch Information From Zillow about a given address.
    """
  end

  defp package() do
    [
      name: "zillow",
      maintainers: ["Jason Clark"],
      licenses: ["MIT"],
      links: %{GitHub: @source_url},
      files: [
        "lib",
        "mix.exs",
        "README.md"
      ]
    ]
  end

  defp aliases do
    [c: "compile", test: ["test"]]
  end

  defp docs do
    [
      main: "readme",
      homepage_url: @source_url,
      source_ref: "v#{@version}",
      canonical: "http://hexdocs.pm/zillow",
      source_url: @source_url,
      extras: ["README.md"]
    ]
  end
end
