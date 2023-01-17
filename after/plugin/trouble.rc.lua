-- same as plugin = require('trouble') in a try/catch block in other langs
local status, plugin = pcall(require, 'trouble')
if not status then
  print('Something went wrong:', plugin)
else
  plugin.setup()
end
