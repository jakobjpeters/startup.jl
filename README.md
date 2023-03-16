
![License](https://img.shields.io/github/license/jakobjpeters/startup.jl)

If Julia is running in an interactive session, `startup.jl` does the following tasks:
- Log each action in `Startup.LOG`
- Set environment variables
- Get desired packages
- If current directory contains `Project.toml`, get that package
