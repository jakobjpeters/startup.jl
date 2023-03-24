
if isinteractive()
    @info "`startup.jl` is running - see `Startup.log()`"
    include("Startup.jl")
    map(["JULIA_EDITOR" => "code", "SHELL" => "bash"]) do pair
        Startup.set_env(pair...)
    end
    Startup.get_package("OhMyREPL")
    Startup.get_project()
end
