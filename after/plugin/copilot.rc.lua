-- copilot oroginal remap
vim.g.copilot_no_tab_map = true
vim.keymap.set('i', "<C-j>", 'copilot#Accept("<CR>")', {noremap = true, silent = true, expr = true, replace_keycodes = false})
