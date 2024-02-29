-- same as plugin = require('indent_blankline') in a try/catch block in other langs
local status, plugin = pcall(require, 'ibl')
if not status then
  print('Something went wrong:', plugin)
else
  plugin.setup{
    scope = { enabled = false },
  }
end
