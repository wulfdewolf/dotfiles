return {
    cmd = { "ruff" , "server"},
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "setup.cfg", "requirements.txt" },
    init_options = {
        settings = {
            format = { enable = true },
        },
    },
}
