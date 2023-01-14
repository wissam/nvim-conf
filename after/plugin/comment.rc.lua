-- same as plugin = require('plugin_name') in a try/catch block in other langs
local status, plugin = pcall(require, 'Comment')
if not status then
  print('Something went wrong:', plugin)
else
  plugin.setup()
end
