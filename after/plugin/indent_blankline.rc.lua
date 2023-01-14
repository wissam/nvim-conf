-- same as plugin = require('indent_blankline') in a try/catch block in other langs
local status, plugin = pcall(require, 'indent_blankline')
if not status then
  print('Something went wrong:', plugin)
else
  plugin.setup{
      char = '▏',
      show_trailing_blankline_indent = false,
  }
end
