defmodule Zillow.Mixfile do
  use Mix.Project

   @version "2.0.0"
   @source_url "https://github.com/mithereal/elixir-zillow"

  def project do
    [
    app: :zillow,
     version: @version,
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     docs: docs(),
     description: description(),
     name: "Zillow Api",
     source_url: "https://github.com/mithereal/elixir-zillow",
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
    {:httpotion, "~> 3.1.0"},
    {:friendly, "~> 1.0"},
    {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
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
      maintainers: ["Jason Clark"],
      licenses: ["MIT"],
      links:  %{GitHub: @source_url },
      files: [
        "lib",
        "mix.exs",
        "README.md",
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
        source_url: @source_url,
        extras: ["README.md"]
      ]
    end

end



