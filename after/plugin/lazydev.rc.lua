-- same as plugin = require('plugin_name') in a try/catch block in other langskk
local status, plugin = pcall(require, 'lazydev')
if not status then
  print('Something went wrong:', plugin)
else
  plugin.setup({
        library = { "lazy.nvim" }
    })
end
