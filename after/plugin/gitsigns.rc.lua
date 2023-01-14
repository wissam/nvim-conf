-- same as plugin = require('gitsigns') in a try/catch block in other langs
local status, plugin = pcall(require, 'gitsigns')
if not status then
  print('Something went wrong:', plugin)
else
  plugin.setup{
    signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
    },
  }
end
