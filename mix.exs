defmodule Defql.Mixfile do
  use Mix.Project

  def project do
    [
      app: :defql,
      version: "0.1.1",
      elixir: "~> 1.3",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      description: "Create elixir functions with SQL as a body.",
      package: package(),
      deps: deps(),
      docs: [
        main: Defql,
        source_url: "https://github.com/fazibear/defql"
      ]
   ]
  end

  def package do
    [
      maintainers: ["Michał Kalbarczyk"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/fazibear/defql"}
   ]
  end

  def application do
    [
      extra_applications: [],
      mod: {Defql.Connection, []}
    ]
  end

  defp deps do
    [
      {:poolboy, ">= 1.0.0"},

      # Drivers
      {:db_connection, "~> 1.1", optional: true},
      {:postgrex, ">= 0.13.0", optional: true},

      {:ecto, "~> 2.1", optional: true},

      {:ex_doc, ">= 0.0.0", only: :dev},
      {:credo, "~> 0.5", only: [:dev, :test]}
    ]
  end
end
