using KnapsackLib
using Documenter

DocMeta.setdocmeta!(KnapsackLib, :DocTestSetup, :(using KnapsackLib); recursive=true)

makedocs(;
    modules=[KnapsackLib],
    authors="Rafael Martinelli",
    repo="https://github.com/rafaelmartinelli/KnapsackLib.jl/blob/{commit}{path}#{line}",
    sitename="KnapsackLib.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://rafaelmartinelli.github.io/KnapsackLib.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/rafaelmartinelli/KnapsackLib.jl",
)
