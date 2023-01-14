local status, plugin = pcall(require, 'lualine')
if not status then
    print('Something went wrong:', plugin)
else
    plugin.setup{
        option = {
            icons_enabled = true,
            theme = 'catppuccin',
        },
    }
end
