
module Startup

import Pkg

const LOG = Expr[]

macro log(expression)
    !in(expression, LOG) && push!(LOG, expression)
    return expression
end

log() = foreach(println ∘ string, LOG)

set_env(key, value) = @eval Startup.@log ENV[$key] = $value

function get_package(name, obtain = "add")
    if isnothing(Base.find_package(name))
        argument = Dict("add" => reduce(*, ["\"", name, "\""]), "develop" => "path = \".\"")[obtain]
        @eval Startup.@log $(Meta.parse(reduce(*, ["Pkg.", obtain, "(", argument, ")"])))
    end

    @eval Main Startup.@log using $(Symbol(name))
end

function get_project()
    if isfile("Project.toml")
        Pkg.activate("", io = devnull)
        name = Pkg.project().name
        Pkg.activate(io = devnull)

        if !isnothing(name)
            get_package("Revise")
            get_package(name, "develop")
        end
    end
end

end # module Startup
