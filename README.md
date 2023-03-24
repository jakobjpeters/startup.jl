
![License](https://img.shields.io/github/license/jakobjpeters/startup.jl)

If Julia is running in an interactive session, `startup.jl` does the following tasks:
- Log each action
- Set environment variables
- Load desired packages
- If current directory contains `Project.toml`, load `Revise` and that project
