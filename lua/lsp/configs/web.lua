-- lua/lsp/configs/web.lua
return {
  -- LSP servers for web development
  servers = {
    -- HTML Language Server
    html = {
      filetypes = { "html" },
      init_options = {
        configurationSection = { "html", "css", "javascript" },
        embeddedLanguages = {
          css = true,
          javascript = true
        },
        provideFormatter = true
      }
    },
    
    -- CSS Language Server
    cssls = {
      filetypes = { "css", "scss", "less" },
      settings = {
        css = {
          validate = true,
          lint = {
            compatibleVendorPrefixes = "warning",
            vendorPrefix = "warning",
            duplicateProperties = "warning",
            emptyRules = "warning"
          }
        },
        scss = {
          validate = true,
          lint = {
            compatibleVendorPrefixes = "warning",
            vendorPrefix = "warning",
            duplicateProperties = "warning",
            emptyRules = "warning"
          }
        },
        less = {
          validate = true,
          lint = {
            compatibleVendorPrefixes = "warning",
            vendorPrefix = "warning",
            duplicateProperties = "warning",
            emptyRules = "warning"
          }
        }
      }
    },
    
    -- TypeScript/JavaScript Server
    tsserver = {
      filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
      settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true
          },
          format = {
            indentSize = 2,
            tabSize = 2,
            convertTabsToSpaces = true
          }
        },
        javascript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true
          },
          format = {
            indentSize = 2,
            tabSize = 2,
            convertTabsToSpaces = true
          }
        }
      }
    },
    
    -- ESLint Language Server
    eslint = {
      filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "vue", "svelte" },
      settings = {
        packageManager = "npm",
        codeAction = {
          disableRuleComment = {
            enable = true,
            location = "separateLine"
          },
          showDocumentation = {
            enable = true
          }
        },
        codeActionOnSave = {
          enable = false,
          mode = "all"
        },
        format = true,
        nodePath = "",
        onIgnoredFiles = "off",
        quiet = false,
        rulesCustomizations = {},
        run = "onType",
        useESLintClass = false,
        validate = "on",
        workingDirectory = {
          mode = "location"
        }
      }
    },
    
    -- Tailwind CSS Language Server
    tailwindcss = {
      filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
      init_options = {
        userLanguages = {
          eelixir = "html-eex",
          eruby = "erb"
        }
      },
      settings = {
        tailwindCSS = {
          classAttributes = { "class", "className", "classList", "ngClass" },
          lint = {
            cssConflict = "warning",
            invalidApply = "error",
            invalidConfigPath = "error",
            invalidScreen = "error",
            invalidTailwindDirective = "error",
            invalidVariant = "error",
            recommendedVariantOrder = "warning"
          },
          validate = true
        }
      }
    }
  },
  
  -- Linters and formatters (requires none-ls)
  linters = {
    -- Prettier for formatting
    prettier = {
      filetypes = { "html", "css", "scss", "less", "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "jsonc", "vue", "svelte", "markdown" },
      source_type = "formatting",
      config = {
        -- Use .prettierrc file if available
        prefer_local = "node_modules/.bin",
        -- Arguments for prettier
        extra_args = { "--single-quote", "--jsx-single-quote" }
      }
    },
    
    -- ESLint for linting JavaScript/TypeScript
    eslint_d = {
      filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
      source_type = "diagnostics",
      config = {
        condition = function()
          return vim.fn.executable("eslint_d") == 1
        end
      }
    },
    
    -- Stylelint for CSS linting
    stylelint = {
      filetypes = { "css", "scss", "less", "sass" },
      source_type = "diagnostics",
      config = {
        -- Use .stylelintrc file if available
      }
    }
  }
}
