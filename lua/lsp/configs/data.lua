-- lua/lsp/configs/data.lua
return {
  -- LSP servers for data formats
  servers = {
    -- JSON Language Server
    jsonls = {
      filetypes = { "json", "jsonc" },
      settings = {
        json = {
          -- Use schemastore to provide JSON schemas
          schemas = require('schemastore').json.schemas(),
          validate = { enable = true },
          format = { enable = true }
        }
      },
      -- Suggest installing schemastore plugin for full schema support
      -- https://github.com/b0o/SchemaStore.nvim
      setup = function()
        if not pcall(require, "schemastore") then
          vim.notify("schemastore.nvim not found. Install it for better JSON schema support.", vim.log.levels.WARN)
        end
      end
    },
    
    -- YAML Language Server
    yamlls = {
      filetypes = { "yaml", "yaml.docker-compose" },
      settings = {
        yaml = {
          -- Use schemastore to provide YAML schemas
          schemas = require('schemastore').yaml.schemas(),
          validate = true,
          format = {
            enable = true,
            singleQuote = false,
            bracketSpacing = true
          },
          hover = true,
          completion = true,
          schemaStore = {
            enable = true,
            url = "https://www.schemastore.org/api/json/catalog.json"
          }
        }
      },
      -- Suggest installing schemastore plugin for full schema support
      setup = function()
        if not pcall(require, "schemastore") then
          vim.notify("schemastore.nvim not found. Install it for better YAML schema support.", vim.log.levels.WARN)
        end
      end
    },
    
    -- XML Language Server
    lemminx = {
      filetypes = { "xml", "xsd", "xsl", "xslt", "svg" },
      settings = {
        xml = {
          logs = {
            client = true
          },
          format = {
            enabled = true,
            splitAttributes = true,
            joinCDATALines = false,
            formatComments = true,
            joinCommentLines = false
          },
          validation = {
            enabled = true,
            schema = true
          },
          server = {
            workDir = "~/.cache/lemminx"
          }
        }
      }
    }
  },
  
  -- Linters and formatters (requires none-ls)
  linters = {
    -- Prettier for JSON formatting
    prettier = {
      filetypes = { "json", "jsonc" },
      source_type = "formatting",
      config = {
        extra_args = { "--parser", "json" }
      }
    },
    
    -- jq for JSON validation and formatting
    jq = {
      filetypes = { "json", "jsonc" },
      source_type = "formatting",
      config = {}
    },
    
    -- xmllint for XML validation and formatting
    xmllint = {
      filetypes = { "xml", "svg" },
      source_type = "diagnostics",
      config = {
        extra_args = { "--noout", "--valid" }
      }
    },
    
    -- xmlformat for XML formatting
    xmlformat = {
      filetypes = { "xml", "svg" },
      source_type = "formatting",
      config = {}
    },
    
    -- yamlfmt for YAML formatting
    yamlfmt = {
      filetypes = { "yaml" },
      source_type = "formatting",
      config = {}
    },
    
    -- yamllint for YAML linting
    yamllint = {
      filetypes = { "yaml" },
      source_type = "diagnostics",
      config = {
        -- Use .yamllint file if available
      }
    }
  }
}
