defmodule AbsintheOneOf.MixProject do
  use Mix.Project

  def project do
    [
      app: :absinthe_one_of,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:absinthe,
       github: "absinthe-graphql/absinthe", commit: "658d510214e3b00eec8a70296e6117b911a0d3df"}
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
