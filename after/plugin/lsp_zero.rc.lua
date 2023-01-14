-- same as plugin = require('lsp-zero') in a try/catch block in other langs
local status, plugin = pcall(require, 'lsp-zero')
if not status then
  print('Something went wrong:', plugin)
else
  plugin.preset('recommended')
  plugin.setup()
end
