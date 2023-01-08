
import Pkg

macro log(expression)
    startup_log = haskey(ENV, "STARTUP_LOG") ? ENV["STARTUP_LOG"] * ";" : "" 
    ENV["STARTUP_LOG"] = startup_log * string(expression)

    return expression
end

function get_package(obtain_package, access_package, name)
    isnothing(Base.find_package(name)) && obtain_package(name)
    @eval @log $(Meta.parse(access_package * " " * name))
end

@sync @async begin
    @log ENV["JULIA_EDITOR"] = "code"
    @log ENV["SHELL"] = "bash"

    get_package(Pkg.add, "import", "Suppressor")

    if isfile("Project.toml")
        get_package(Pkg.add, "import", "TOML")
        name = TOML.parsefile("Project.toml")["name"]

        get_package(Pkg.develop, "using", name)
        get_package(Pkg.add, "using", "Revise")
    end

    get_package(Pkg.add, "using", "OhMyREPL")
end

@async @Suppressor.suppress @log Pkg.update()
