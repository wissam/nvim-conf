-- lua/lsp/configs/shell_advanced.lua
return {
  -- LSP servers for advanced shell scripting
  servers = {
    -- Enhanced Bash Language Server
    bashls = {
      filetypes = { "sh", "bash", "zsh", "shell" },
      settings = {
        bashIde = {
          -- Glob pattern for shell scripts
          globPattern = "**/*@(.sh|.bash|.zsh|.inc|.command)",
          -- Use ShellCheck for enhanced linting if installed
          enableSourceErrorDiagnostics = true,
          -- Include all workspace symbols
          includeAllWorkspaceSymbols = true
        }
      },
      -- Root directory patterns for shell projects
      root_dir = function(fname)
        return require("lspconfig").util.root_pattern(
          ".shellcheckrc",
          ".bash_profile",
          ".bashrc",
          ".zshrc",
          ".profile",
          "*.sh",
          "*.bash",
          "*.zsh",
          ".git"
        )(fname)
      end,
      -- Initialize options
      init_options = {
        -- Detect shell dialect
        shellcheckPath = "shellcheck",
        enableSourceErrorDiagnostics = true
      }
    },
    
    -- Powershell Language Server for Windows scripting
    powershell_es = {
      filetypes = { "ps1", "psm1", "psd1", "powershell" },
      -- Root directory patterns
      root_dir = function(fname)
        return require("lspconfig").util.root_pattern("*.ps1", "*.psm1", "*.psd1", ".git")(fname)
      end,
      -- Language server settings
      settings = {
        powershell = {
          codeFormatting = {
            preset = "OTBS", -- "Allman", "OTBS", "Stroustrup"
            alignPropertyValuePairs = true,
            ignoreOneLineBlock = true,
            newLineAfterCloseBrace = true,
            useCorrectCasing = true,
            whitespaceAfterSeparator = true,
            whitespaceAroundOperator = true,
            whitespaceBetweenParameters = true
          }
        }
      }
    }
  },
  
  -- Linters and formatters (requires none-ls)
  linters = {
    -- Enhanced ShellCheck configuration
    shellcheck = {
      filetypes = { "sh", "bash", "zsh", "shell" },
      source_type = "diagnostics",
      config = {
        command = "shellcheck",
        args = {
          "--format=json",
          "--external-sources",  -- Allow sourcing of external scripts
          "--enable=all",        -- Enable all checks
          "--severity=style",    -- Show all severity levels
          "--shell=bash",        -- Target shell dialect
          "-"
        },
        to_stdin = true,
        format = "json",
        on_output = function(params)
          local diagnostics = {}
          if params.output and params.output ~= "" then
            local issues = vim.json.decode(params.output)
            if issues and #issues > 0 then
              for _, issue in ipairs(issues) do
                table.insert(diagnostics, {
                  row = issue.line,
                  col = issue.column,
                  end_col = issue.endColumn,
                  code = issue.code,
                  message = issue.message,
                  severity = ({
                    error = 1,
                    warning = 2,
                    info = 3,
                    style = 4
                  })[issue.level] or 2,
                  source = "shellcheck"
                })
              end
            end
          end
          return diagnostics
        end
      }
    },
    
    -- Advanced shfmt configuration
    shfmt = {
      filetypes = { "sh", "bash", "zsh", "shell" },
      source_type = "formatting",
      config = {
        command = "shfmt",
        args = {
          "-i", "2",   -- 2 space indentation
          "-bn",       -- Binary ops like && and | may start a line
          "-ci",       -- Switch cases will be indented
          "-sr",       -- space after redirect operators
          "-kp",       -- Keep column alignment paddings
          "-ln", "bash" -- Language dialect
        },
        to_stdin = true
      }
    },
    
    -- explainshell integration
    explainshell = {
      filetypes = { "sh", "bash", "zsh", "shell" },
      source_type = "hover",
      config = {
        command = "explainshell",
        args = { "--json", "{query}" },
        to_stdin = false,
        format = "json",
        -- Hover handler for shell commands
        -- This is a custom handler example
        on_output = function(params)
          if params.output and params.output ~= "" then
            local result = vim.json.decode(params.output)
            if result and result.explanation then
              return result.explanation
            end
          end
          return "No explanation available"
        end
      }
    },
    
    -- PSScriptAnalyzer for PowerShell linting
    psalm = {
      filetypes = { "ps1", "psm1", "psd1", "powershell" },
      source_type = "diagnostics",
      config = {
        command = "pwsh",
        args = {
          "-NoProfile",
          "-Command",
          "Invoke-ScriptAnalyzer -Path {temp_path} -Settings PSGallery -OutputFormat json | ConvertTo-Json"
        },
        to_temp_file = true,
        format = "json",
        check_exit_code = function(code)
          return code < 2  -- PWsh uses different exit codes
        end,
        -- Parse PSScriptAnalyzer output
        on_output = function(params)
          local diagnostics = {}
          if params.output and params.output ~= "" then
            local results = vim.json.decode(params.output)
            if results and #results > 0 then
              for _, result in ipairs(results) do
                table.insert(diagnostics, {
                  row = result.Line,
                  col = result.Column,
                  message = result.Message,
                  code = result.RuleName,
                  severity = ({
                    Error = 1,
                    Warning = 2,
                    Information = 3,
                    ParseError = 1
                  })[result.Severity] or 2,
                  source = "PSScriptAnalyzer"
                })
              end
            end
          end
          return diagnostics
        end
      }
    }
  }
}
