-- lua/lsp/configs/go.lua
return {
  -- LSP servers for Go
  servers = {
    -- Go language server
    gopls = {
      filetypes = { "go", "gomod", "gowork", "gotmpl" },
      -- Root directory patterns
      root_dir = function(fname)
        return require("lspconfig").util.root_pattern("go.mod", ".git")(fname)
      end,
      -- Gopls settings
      settings = {
        gopls = {
          analyses = {
            unusedparams = true,
            shadow = true,
            nilness = true,
            unusedwrite = true,
            useany = true,
          },
          staticcheck = true,
          gofumpt = true, -- Stricter formatting than gofmt
          usePlaceholders = true,
          completeUnimported = true,
          matcher = "fuzzy",
          diagnosticsDelay = "500ms",
          symbolMatcher = "fuzzy",
          buildFlags = {"-tags=integration,e2e"},
          -- Set experimentalPostfixCompletions to true for postfix snippets
          experimentalPostfixCompletions = true,
        }
      },
      -- Initialize gopls with your preferred settings
      init_options = {
        usePlaceholders = true,
        completeUnimported = true,
      }
    }
  },
  
  -- Linters and formatters (requires none-ls)
  linters = {
    -- gofmt for code formatting
    gofmt = {
      filetypes = { "go" },
      source_type = "formatting",
      config = {
        -- No extra args needed for standard gofmt
      }
    },
    
    -- goimports for formatting and managing imports
    goimports = {
      filetypes = { "go" },
      source_type = "formatting",
      config = {
        -- You could use goimports_reviser instead with proper args
      }
    },
    
    -- golangci-lint for comprehensive linting
    golangci_lint = {
      filetypes = { "go" },
      source_type = "diagnostics",
      config = {
        -- Specify config file if not using .golangci.yml
        -- args = { "--config=.golangci.yml" }
      }
    },
    
    -- gotest for running tests
    gotest = {
      filetypes = { "go" },
      source_type = "diagnostics",
      config = {
        -- Test flags
        -- args = { "-v" }
      }
    }
  }
}
