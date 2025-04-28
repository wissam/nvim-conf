-- lua/lsp/configs/python.lua
return {
  -- LSP servers for Python
  servers = {
    -- Pyright for type checking and intellisense
    pyright = {
      filetypes = { "python" },
      settings = {
        python = {
          analysis = {
            typeCheckingMode = "basic",  -- Can be "off", "basic", or "strict"
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticMode = "workspace"
          }
        }
      }
    },
    
    -- Ruff LSP for fast linting
    ruff = {
      filetypes = { "python" },
      -- Customize ruff settings as needed
      settings = {
        ruff = {
          lint = {
            run = "onSave",
          },
          -- Specify configuration file if not using pyproject.toml
          -- configPath = "~/.ruff.toml",
        }
      }
    }
  },
  
  -- Linters and formatters (requires none-ls)
  linters = {
    -- Black for code formatting
    black = {
      filetypes = { "python" },
      source_type = "formatting",
      config = {
        -- Any specific configuration like line length
        extra_args = { "--line-length", "88" }
      }
    },
    
    -- isort for import sorting
    isort = {
      filetypes = { "python" },
      source_type = "formatting",
      config = {
        extra_args = { "--profile", "black" }  -- Make isort compatible with black
      }
    },
    
    -- mypy for advanced type checking
    mypy = {
      filetypes = { "python" },
      source_type = "diagnostics",
      config = {
        extra_args = { "--ignore-missing-imports", "--disallow-untyped-defs" }
      }
    }
  }
}
