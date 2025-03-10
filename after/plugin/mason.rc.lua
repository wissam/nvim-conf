-- same as plugin = require('plugin_name') in a try/catch block in other langs
local lsp_zero  = require('lsp-zero')
local status, plugin = pcall(require, 'mason')
if not status then
  print('Something went wrong:', plugin)
else
  plugin.setup()
end

local status, plugin = pcall(require, 'mason-lspconfig')
if not status then
  print('Something went wrong:', plugin)
else
  plugin.setup({
    ensure_installed = {'lua_ls', 'gopls', 'pyright', 'rust_analyzer', 'terraformls'},
    handlers = {
        function(server_name)
            lsp_zero.default_setup(server_name)
        end,
    },
    })
end
