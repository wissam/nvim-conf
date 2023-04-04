-- same as plugin = require('lsp-zero') in a try/catch block in other langs
local status, plugin = pcall(require, 'lsp-zero')
if not status then
    print('Something went wrong:', plugin)
else
    plugin.preset('recommended')
    plugin.on_attach(function(client, bufnr)
        plugin.default_keymaps({buffer = bufnr})
    end)
    require('lspconfig').gopls.setup(plugin.setup({
        cmd = {'gopls'},
        filetypes = {'go', 'gomod','gowork','gotmpl'},
        root_dir = plugin.root_pattern('go.mod', '.git'),
        single_file_support = true,
        settings = {
            gopls = {
                analyses = {
                    unusedparams = true,
                },
                staticcheck = true,
                gofumpt = true,
            },
        },
    }))

    plugin.setup()
    vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        update_in_insert = false,
        underline = true,
        severity_sort = false,
        float = true,
    })
end
