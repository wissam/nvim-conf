-- lua/lsp/configs/php.lua
return {
  -- LSP servers for PHP
  servers = {
    -- Intelephense - Feature-rich PHP language server
    intelephense = {
      filetypes = { "php" },
      -- Root directory patterns for PHP projects
      root_dir = function(fname)
        return require("lspconfig").util.root_pattern(
          "composer.json",
          ".git",
          "artisan", -- Laravel
          "index.php"
        )(fname)
      end,
      -- Intelephense settings
      settings = {
        intelephense = {
          files = {
            maxSize = 1000000, -- Larger file size limit
            associations = { -- Additional PHP file associations
              "*.php",
              "*.phtml",
              "*.inc",
              "*.module",
              "*.install",
              "*.theme"
            },
            exclude = {
              "**/.git/**",
              "**/.svn/**",
              "**/.hg/**",
              "**/CVS/**",
              "**/.DS_Store/**",
              "**/node_modules/**",
              "**/bower_components/**",
              "**/vendor/**/{Tests,tests}/**", -- Skip vendor tests
              "**/.history/**",
              "**/vendor/**/vendor/**"
            }
          },
          diagnostics = {
            enable = true,
          },
          completion = {
            insertUseDeclaration = true,  -- Auto-add use declarations
            fullyQualifyGlobalConstantsAndFunctions = false,
            triggerParameterHints = true,
            maxItems = 100,
          },
          phpdoc = {
            returnVoid = false, -- Don't add @return void
          },
          telemetry = {
            enable = false, -- Disable telemetry
          },
          -- Uncomment and set license key if you have Intelephense premium
          -- licenceKey = "your-key-here",
          environment = {
            phpVersion = "8.2.0", -- Set your PHP version
            shortOpenTag = false
          }
        }
      },
      -- Initialize options
      init_options = {
        storagePath = vim.fn.stdpath("cache") .. "/intelephense",
        licenceKey = nil, -- Set your license key here if you have one
        clearCache = false
      }
    },
    
    -- phpactor - Alternative PHP language server with refactoring focus
    phpactor = {
      filetypes = { "php" },
      enabled = function()
        -- Only enable if phpactor is available 
        -- and if you specifically prefer it over intelephense
        return vim.fn.executable("phpactor") == 1 and
               vim.g.use_phpactor == true  -- You can set this in your config
      end,
      -- Root directory patterns
      root_dir = function(fname)
        return require("lspconfig").util.root_pattern(
          "composer.json",
          ".git",
          "phpactor.yml", 
          ".phpactor.yml"
        )(fname)
      end,
      -- Server settings
      init_options = {
        ["language_server_phpstan.enabled"] = true,
        ["language_server_psalm.enabled"] = true,
        ["language_server.diagnostics_on_update"] = true,
        ["language_server.diagnostics_on_save"] = true,
        ["language_server.diagnostics_on_open"] = true
      }
    }
  },
  
  -- Linters and formatters (requires none-ls)
  linters = {
    -- PHP-CS-Fixer for code style fixing
    php_cs_fixer = {
      filetypes = { "php" },
      source_type = "formatting",
      config = {
        command = "php-cs-fixer",
        args = {
          "fix",
          "--rules=@PSR12,@Symfony",
          "--using-cache=no",
          "--no-interaction",
          "--quiet",
          "-"
        },
        to_stdin = true,
        -- Try to use project-specific config if available
        condition = function()
          local has_local_config = vim.fn.filereadable(".php-cs-fixer.php") == 1 or
                                   vim.fn.filereadable(".php-cs-fixer.dist.php") == 1 or
                                   vim.fn.filereadable(".php_cs") == 1 or
                                   vim.fn.filereadable(".php_cs.dist") == 1
          
          if has_local_config then
            return true
          else
            return vim.fn.executable("php-cs-fixer") == 1
          end
        end,
        -- Use project-specific config if available
        runtime_condition = function(params)
          local config_files = {
            ".php-cs-fixer.php",
            ".php-cs-fixer.dist.php",
            ".php_cs",
            ".php_cs.dist"
          }
          
          for _, config_file in ipairs(config_files) do
            if vim.fn.filereadable(config_file) == 1 then
              params.args = {
                "fix",
                "--no-interaction",
                "--quiet",
                "-"
              }
              return true
            end
          end
          
          return true
        end
      }
    },
    
    -- PHPCS - PHP CodeSniffer for style checking
    phpcs = {
      filetypes = { "php" },
      source_type = "diagnostics",
      config = {
        command = "phpcs",
        args = {
          "--report=json",
          "--standard=PSR12",
          "-"
        },
        to_stdin = true,
        format = "json",
        -- Use project-specific ruleset if available
        runtime_condition = function(params)
          local rulesets = {
            "phpcs.xml",
            "phpcs.xml.dist",
            ".phpcs.xml",
            ".phpcs.xml.dist",
            "ruleset.xml",
            "phpcs.ruleset.xml"
          }
          
          for _, ruleset in ipairs(rulesets) do
            if vim.fn.filereadable(ruleset) == 1 then
              params.args = {
                "--report=json",
                "-"
              }
              return true
            end
          end
          
          return true
        end,
        -- Parse JSON output from phpcs
        on_output = function(params)
          local diagnostics = {}
          if params.output and params.output ~= "" then
            local decoded = vim.json.decode(params.output)
            if decoded and decoded.files and next(decoded.files) then
              local issues = next(decoded.files) and decoded.files[next(decoded.files)]
              
              if issues and issues.messages and #issues.messages > 0 then
                for _, issue in ipairs(issues.messages) do
                  table.insert(diagnostics, {
                    row = issue.line,
                    col = issue.column,
                    message = issue.message,
                    code = issue.source,
                    severity = (issue.type == "ERROR") and 1 or 2,
                    source = "phpcs"
                  })
                end
              end
            end
          end
          return diagnostics
        end
      }
    },
    
    -- PHPStan - PHP Static Analysis Tool
    phpstan = {
      filetypes = { "php" },
      source_type = "diagnostics",
      config = {
        command = "phpstan",
        args = {
          "analyze",
          "--error-format=json",
          "--no-progress",
          "--level=5", -- Default level (0-9, 9 being the strictest)
          "--memory-limit=1G",
          "%file"
        },
        to_temp_file = true,
        format = "json",
        -- Check for project-specific config
        runtime_condition = function(params)
          local config_files = {
            "phpstan.neon",
            "phpstan.neon.dist",
            "phpstan.dist.neon"
          }
          
          for _, config_file in ipairs(config_files) do
            if vim.fn.filereadable(config_file) == 1 then
              params.args = {
                "analyze",
                "--error-format=json",
                "--no-progress",
                "--memory-limit=1G",
                "%file"
              }
              return true
            end
          end
          
          return true
        end,
        -- Parse PHPStan JSON output
        on_output = function(params)
          local diagnostics = {}
          if params.output and params.output ~= "" then
            local decoded = vim.json.decode(params.output)
            if decoded and decoded.files and next(decoded.files) then
              local filename = params.temp_path or params.bufname
              local basename = vim.fn.fnamemodify(filename, ":t")
              
              for file, issues in pairs(decoded.files) do
                if file:match(basename) and issues.messages then
                  for _, issue in ipairs(issues.messages) do
                    table.insert(diagnostics, {
                      row = issue.line,
                      message = issue.message,
                      severity = 2, -- Warning
                      source = "phpstan"
                    })
                  end
                end
              end
            end
          end
          return diagnostics
        end
      }
    },
    
    -- PSALM - PHP Static Analysis Linting Machine
    psalm = {
      filetypes = { "php" },
      source_type = "diagnostics",
      config = {
        command = "psalm",
        args = {
          "--output-format=json",
          "--no-progress",
          "%file"
        },
        to_temp_file = true,
        format = "json",
        -- Parse PSALM JSON output
        on_output = function(params)
          local diagnostics = {}
          if params.output and params.output ~= "" then
            local decoded = vim.json.decode(params.output)
            if decoded and decoded.messages then
              for _, issue in ipairs(decoded.messages) do
                table.insert(diagnostics, {
                  row = issue.line_from,
                  col = issue.column_from,
                  end_row = issue.line_to,
                  end_col = issue.column_to,
                  severity = (issue.severity == "error") and 1 or 2,
                  message = issue.message,
                  code = issue.type,
                  source = "psalm"
                })
              end
            end
          end
          return diagnostics
        end
      }
    },
    
    -- Pint - Laravel-specific formatter (Laravel 9+)
    pint = {
      filetypes = { "php" },
      source_type = "formatting",
      config = {
        command = "pint",
        args = {},
        to_temp_file = true,
        -- Only run in Laravel projects
        condition = function()
          return vim.fn.filereadable("artisan") == 1 and vim.fn.executable("pint") == 1
        end
      }
    },
    
    -- PHP runtime errors checking
    php = {
      filetypes = { "php" },
      source_type = "diagnostics",
      config = {
        command = "php",
        args = { "-l", "-d", "display_errors=1", "-d", "log_errors=0", "%file" },
        to_temp_file = true,
        format = "line",
        check_exit_code = function(code)
          return code ~= 0
        end,
        -- Parse PHP syntax check output
        on_output = function(params, done)
          local diagnostics = {}
          if params.output and params.output ~= "" then
            local pattern = "Parse error: syntax error, (.*) in (.*) on line (%d+)"
            for message, _, line in string.gmatch(params.output, pattern) do
              table.insert(diagnostics, {
                row = tonumber(line),
                message = message,
                severity = 1, -- Error
                source = "php"
              })
            end
            
            -- Special case for deprecated feature errors
            local deprecated_pattern = "Deprecated: (.*) in (.*) on line (%d+)"
            for message, _, line in string.gmatch(params.output, deprecated_pattern) do
              table.insert(diagnostics, {
                row = tonumber(line),
                message = "Deprecated: " .. message,
                severity = 2, -- Warning
                source = "php"
              })
            end
          end
          return diagnostics
        end
      }
    }
  }
}
