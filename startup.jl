
module Startup

import Pkg
using Distributed: addprocs, remotecall, rmprocs
using TOML: parsefile

const LOG = Expr[]

macro log(expression)
    return last(push!(LOG, expression))
end

function update_packages()
    worker = first(addprocs(1))
    remotecall(worker) do
        redirect_stderr()
        @log Pkg.update()
    end
    rmprocs(worker)
end
#=
Source:
https://discourse.julialang.org/t/what-is-in-your-startup-jl/18228
=#

get_project_name() = parsefile("Project.toml")["name"]

function get_package(obtain_package, name)
    if isnothing(Base.find_package(name))
        if obtain_package == "develop"
            arg = "path = \".\""
        else
            arg = "\"" * name * "\""
        end

        @eval Startup.@log $(Meta.parse("Pkg." * obtain_package * "(" * arg * ")"))
    end
end

end

@info "`startup.jl` is running - see `Startup.LOG`"

Startup.update_packages()

Startup.@log ENV["JULIA_EDITOR"] = "code"
Startup.@log ENV["SHELL"] = "bash"

if isfile("Project.toml")
    name = Startup.get_project_name()
    Startup.get_package("develop", name)
    @eval Startup.@log $(Meta.parse("using " * name))

    Startup.get_package("add", "Revise")
    Startup.@log using Revise
end

Startup.get_package("add", "OhMyREPL")
Startup.@log using OhMyREPL
