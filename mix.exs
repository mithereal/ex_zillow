defmodule Zillow.Mixfile do
  use Mix.Project

   @version "0.2.0"

  def project do
    [
    app: :zillow,
     version: @version,
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     description: description(),
     name: "Zillow Api",
     source_url: "https://github.com/mithereal/zillow",
     package: package()
     ]
  end

  def application do
    [extra_applications: [:logger]]
  end


  defp deps do
    [
    {:httpotion, "~> 3.0.2"},
    {:friendly, "~> 1.0"},
    {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp description() do
    """
   This will fetch Information From Zillow about a given address.
    """
  end

  defp package() do
    [maintainers: ["Jason Clark"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/mithereal/zillow"}]
  end

  defp aliases do
        [c: "compile"]
  end

end



