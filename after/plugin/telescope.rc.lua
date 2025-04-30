-- same as plugin = require('telescope') in a try/catch block in other langs
local status, telescope = pcall(require, 'telescope')
if not status then
  print('Something went wrong:', telescope)
else
  telescope.setup{
    defaults = {
      mappings = {
        i = {
          ["<C-u>"] = false,
          ["<C-d>"] = false,
        },
      },
    },
  }
end

-- Enable telescope fzf native
telescope.load_extension('fzf')


--Add leader shortcuts
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers)
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files)
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').current_buffer_fuzzy_find)
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags)
vim.keymap.set('n', '<leader>ft', require('telescope.builtin').tags)
vim.keymap.set('n', '<leader>fd', require('telescope.builtin').grep_string)
vim.keymap.set('n', '<leader>fp', require('telescope.builtin').live_grep)
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').git_files)
vim.keymap.set('n', '<leader>fo', function()
  require('telescope.builtin').tags { only_current_buffer = true }
end)
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles)
vim.keymap.set('n', '<leader>fc', require('telescope.builtin').commands)
