-- same as plugin = require('lsp-zero') in a try/catch block in other langs
local status, lsp = pcall(require, 'lsp-zero')
if not status then
    print('Something went wrong:', lsp)
else
    lsp.preset('recommended')
    lsp.on_attach(function(client, bufnr)
        lsp.default_keymaps({buffer = bufnr})
    end)
    require('lspconfig').gopls.setup({
        cmd = {'gopls'},
        filetypes = {'go', 'gomod','gowork','gotmpl'},
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
    })

    lsp.setup()
    vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        update_in_insert = false,
        underline = true,
        severity_sort = false,
        float = true,
    })
end
