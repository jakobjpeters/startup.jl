
![License](https://img.shields.io/github/license/jakobjpeters/startup.jl)

`startup.jl` does the following tasks asynchronously:
- Log each action in `ENV["STARTUP_LOG"]`
- Set environment variables
- Get utility packages for `startup.jl`
- Get desired packages
- If current directory contains `Project.toml`, get that package
- Update packages
