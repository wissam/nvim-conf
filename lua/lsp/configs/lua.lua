-- lua/lsp/configs/lua.lua
return {
  -- Define LSP servers for Lua
  servers = {
    lua_ls = {
      filetypes = { "lua" },
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" }
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false
          },
          telemetry = {
            enable = false
          }
        }
      }
    }
  },
  
  -- Define linters for Lua (requires none-ls)
  linters = {
    -- Linting with luacheck
    luacheck = {
      filetypes = { "lua" },
      source_type = "diagnostics", -- none-ls source type
      config = {
        -- Configuration for the linter
        extra_args = {
          "--globals", "vim",
          "--no-max-line-length" 
        }
      }
    },
    
    -- Formatting with stylua
    stylua = {
      filetypes = { "lua" },
      source_type = "formatting", -- none-ls source type
      config = {
        -- Any specific configuration
      }
    }
  }
}
