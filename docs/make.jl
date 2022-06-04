using Knapsacks
using Documenter

DocMeta.setdocmeta!(Knapsacks, :DocTestSetup, :(using Knapsacks); recursive=true)

makedocs(;
    modules=[Knapsacks],
    authors="Rafael Martinelli",
    repo="https://github.com/rafaelmartinelli/Knapsacks.jl/blob/{commit}{path}#{line}",
    sitename="Knapsacks.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://rafaelmartinelli.github.io/Knapsacks.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md"
    ],
)

deploydocs(;
    repo="github.com/rafaelmartinelli/Knapsacks.jl",
)
