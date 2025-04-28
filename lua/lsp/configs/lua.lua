vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
                path = vim.split(package.path, ';'),
            },
            diagnostics = {
                globals = { 'vim' },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file('', true),
                maxPreload = 1000,
                preloadFileSize = 1000,
            },
            telemetry = {
                enable = false,
            },
        },
    },
})
