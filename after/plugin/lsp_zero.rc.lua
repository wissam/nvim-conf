-- same as plugin = require('lsp-zero') in a try/catch block in other langs
local status, lsp = pcall(require, 'lsp-zero')
if not status then
    print('Something went wrong:', lsp)
else
    lsp.on_attach(function(client, bufnr)
        lsp.default_keymaps({buffer = bufnr})
    end)

    local lspconfig_defaults = require('lspconfig').util.default_config
    lspconfig_defaults.capabilities = vim.tbl_deep_extend(
        'force',
        lspconfig_defaults.capabilities,
        require('cmp_nvim_lsp').default_capabilities()
    )
    
    require('lspconfig').terraformls.setup({
        cmd = {'terraform-ls', 'serve'},
        filetypes = {'terraform','hcl', 'tf', 'tfvars'},
        root_dir = require('lspconfig').util.root_pattern('.terraform', '.git'),
        settings = {
            telemetry = {
                enable = false,
            },
            lint = {
                enabled = true,
            },

        },
    })

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
    require'lspconfig'.lua_ls.setup ({
        settings = {
            Lua = {
                diagnostics = {
                    globals = { 'vim' }
                }
            }
        }
    })
    local configs = require 'lspconfig/configs'

    require'lspconfig'.golangci_lint_ls.setup {
        filetypes = {'go','gomod'}
    }
    local cmp = require('cmp')

    cmp.setup({
        sources = {
            {name = 'nvim_lsp'},
        },
        snippet = {
            expand = function(args)
                -- You need Neovim v0.10 to use vim.snippet
                vim.snippet.expand(args.body)
            end,
        },
        mapping = cmp.mapping.preset.insert({}),
    })
    vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        update_in_insert = false,
        underline = true,
        severity_sort = false,
        float = true,
    })
end
