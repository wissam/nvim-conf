-- same as plugin = require('plugin_name') in a try/catch block in other langs
local status, plugin = pcall(require, 'catppuccin')
if not status then
  print('Something went wrong:', plugin)
else
  plugin.setup()
  vim.g.catppuccin_flavour = "macchiato"
  vim.cmd [[colorscheme catppuccin]]
end
