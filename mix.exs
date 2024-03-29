defmodule AmSaml.Mixfile do
  use Mix.Project

  def project do
    [
      app: :am_saml,
      version: "0.4.0",
      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      package: package(),
      description: "SAML interface for authentication.",

      # Docs
      name: "AmSaml",
      source_url: "https://github.com/ascential/am-saml",
      docs: [
       main: "AmSaml", # The main page in the docs
       extras: ["README.md"]
      ]
   ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger, :crypto]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:sweet_xml, "~> 0.7"},
      {:credo, "~> 1.4.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.22.0", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      maintainers: ["schinsue", "shinyford"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/ascential/am-saml"}
    ]
  end
end
