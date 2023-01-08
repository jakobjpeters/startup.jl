
macro log(expression)
    println("  ", expression)
    return expression
end

function get_package(obtain_package, access_package, name)
    isnothing(Base.find_package(name)) && obtain_package(name)
    @eval @log $(Meta.parse(access_package * " " * name))
end

println("startup.jl:")

@log ENV["JULIA_EDITOR"] = "code"
@log ENV["SHELL"] = "bash"

@log import Pkg

get_package(Pkg.add, "import", "Suppressor")

if isfile("Project.toml")
    get_package(Pkg.add, "import", "TOML")
    const name = TOML.parsefile("Project.toml")["name"]
    
    get_package(Pkg.develop, "using", name)
    get_package(Pkg.add, "using", "Revise")
end

get_package(Pkg.add, "using", "OhMyREPL")

const update_packages = @task @log Pkg.update()
@Suppressor.suppress schedule(update_packages)
