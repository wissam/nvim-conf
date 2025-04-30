-- same as plugin = require('nvim-treesitter.configs') in a try/catch block in other langs
local status, plugin = pcall(require, 'nvim-treesitter.configs')
if not status then
  print('Something went wrong:', plugin)
else
  plugin.setup{
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "css",
        "dockerfile",
        "go",
        "html",
        "javascript",
        "json",
        "lua",
        "python",
        "regex",
        "rust",
        "toml",
        "typescript",
        "yaml",
        "hcl",
        "markdown",
        "sql",
        "terraform",
      },
      auto_install = true,
      sync_install = false,
      highlight = {
          enable = true, -- false will disable the whole extension
      },
      incremental_selection = {
          enable = true,
          keymaps = {
              init_selection = 'gnn',
              node_incremental = 'grn',
              scope_incremental = 'grc',
              node_decremental = 'grm',
          },
      },
      indent = {
          enable = true,
      },
      textobjects = {
          select = {
              enable = true,
              lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
              keymaps = {
                  -- You can use the capture groups defined in textobjects.scm
                  ['af'] = '@function.outer',
                  ['if'] = '@function.inner',
                  ['ac'] = '@class.outer',
                  ['ic'] = '@class.inner',
              },
          },
          move = {
              enable = true,
              set_jumps = true, -- whether to set jumps in the jumplist
              goto_next_start = {
                  [']m'] = '@function.outer',
                  [']]'] = '@class.outer',
              },
              goto_next_end = {
                  [']M'] = '@function.outer',
                  [']['] = '@class.outer',
              },
              goto_previous_start = {
                  ['[m'] = '@function.outer',
                  ['[['] = '@class.outer',
              },
              goto_previous_end = {
                  ['[M'] = '@function.outer',
                  ['[]'] = '@class.outer',
              },
          },
      },
  }
end
