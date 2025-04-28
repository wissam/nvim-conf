-- lua/lsp/configs/markdown.lua
return {
  -- LSP servers for Markdown
  servers = {
    -- Markdown Language Server
    marksman = {
      filetypes = { "markdown", "markdown.mdx" },
      -- Root directory patterns for Markdown projects
      root_dir = function(fname)
        return require("lspconfig").util.root_pattern(".git", ".marksman.toml")(fname)
      end
    },
    
    -- Vale for enhanced prose linting (if you have it set up as LSP)
    -- Note: This requires custom setup, not a standard LSP
    vale_ls = {
      filetypes = { "markdown", "text" },
      -- You would need to have vale_ls configured and installed
      -- This is not a standard LSP and may require custom setup
      enabled = function()
        return vim.fn.executable("vale-ls") == 1
      end
    },
    
    -- LTeX for grammar and spell checking
    ltex = {
      filetypes = { "markdown", "text" },
      settings = {
        ltex = {
          enabled = { "markdown", "text" },
          language = "en-US", -- Change to your language
          diagnosticSeverity = "information",
          sentenceCacheSize = 2000,
          additionalRules = {
            enablePickyRules = true,
            motherTongue = "en-US",
          },
          dictionary = {},
          disabledRules = {},
          hiddenFalsePositives = {}
        }
      }
    }
  },
  
  -- Linters and formatters (requires none-ls)
  linters = {
    -- markdownlint for linting
    markdownlint = {
      filetypes = { "markdown" },
      source_type = "diagnostics",
      config = {
        -- Use .markdownlint.json or .markdownlint.yaml if available
      }
    },
    
    -- Prettier for formatting
    prettier = {
      filetypes = { "markdown" },
      source_type = "formatting",
      config = {
        extra_args = { "--parser", "markdown" }
      }
    },
    
    -- vale for prose linting
    vale = {
      filetypes = { "markdown", "text" },
      source_type = "diagnostics",
      config = {
        -- Vale needs to be configured separately via .vale.ini
      }
    },
    
    -- Alex for catching insensitive language
    alex = {
      filetypes = { "markdown", "text" },
      source_type = "diagnostics",
      config = {}
    },
    
    -- proselint for prose style issues
    proselint = {
      filetypes = { "markdown", "text" },
      source_type = "diagnostics",
      config = {
        -- Use .proselintrc if available
      }
    },
    
    -- write-good for suggestions on writing style
    write_good = {
      filetypes = { "markdown", "text" },
      source_type = "diagnostics",
      config = {
        extra_args = { "--no-passive" }
      }
    }
  }
}
