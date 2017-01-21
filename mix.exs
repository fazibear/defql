defmodule Defql.Mixfile do
  use Mix.Project

  def project do
    [
      app: :defql,
      version: "0.1.0",
      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps()
   ]
  end

  def application do
    [
      extra_applications: [:logger, :postgrex],
      mod: {Defql.Connection, []}
    ]
  end

  defp deps do
    [
      {:poolboy, "~> 1.5"},

      # Drivers
      {:db_connection, "~> 1.1", optional: true},
      {:postgrex, ">= 0.13.0", optional: true},

      {:ecto, "~> 2.0", optional: true},

      {:credo, "~> 0.5", only: [:dev, :test]}
    ]
  end
end
