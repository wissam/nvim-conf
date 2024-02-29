local status, plugin = pcall(require, 'lualine')
if not status then
    print('Something went wrong:', plugin)
else
    plugin.setup({
        options = {
            icons_enabled = true,
            theme = "catppuccin",
            component_separators = ' ',
            section_separators = { left = '', right = '' },
        },
    })
end
