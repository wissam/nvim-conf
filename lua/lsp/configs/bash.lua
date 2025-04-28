-- lua/lsp/configs/bash.lua
return {
  -- LSP servers for Bash
  servers = {
    -- Bash Language Server
    bashls = {
      filetypes = { "sh", "bash", "zsh" },
      -- Configure the bash language server
      settings = {
        bashIde = {
          -- Set to true to use 'shellcheck' for linting if installed
          enableSourceErrorDiagnostics = true,
          -- Glob pattern for finding shell scripts to analyze
          globPattern = "**/*@(.sh|.inc|.bash|.command)",
          -- Include source directives analysis
          includeAllWorkspaceSymbols = true
        }
      }
    }
  },
  
  -- Linters and formatters (requires none-ls)
  linters = {
    -- shellcheck for linting shell scripts
    shellcheck = {
      filetypes = { "sh", "bash", "zsh" },
      source_type = "diagnostics",
      config = {
        -- Additional arguments for shellcheck
        extra_args = { 
          "--severity=style", -- style, info, warning, error
          "--shell=bash",
          "--enable=all"
        }
      }
    },
    
    -- shfmt for formatting shell scripts
    shfmt = {
      filetypes = { "sh", "bash", "zsh" },
      source_type = "formatting",
      config = {
        extra_args = { 
          "-i", "2",   -- 2 space indentation
          "-ci",       -- switch cases indented
          "-bn",       -- binary ops like && and | may start a line
          "-sr"        -- redirect operators will be followed by a space
        }
      }
    },
    
    -- beautysh as an alternative formatter
    beautysh = {
      filetypes = { "sh", "bash", "zsh" },
      source_type = "formatting",
      config = {
        extra_args = { "--indent-size", "2" }
      }
    }
  }
}
