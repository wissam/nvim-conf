-- lua/lsp/configs/pulumi.lua
return {
  -- LSP servers for Pulumi
  servers = {
    -- TypeScript for Pulumi TypeScript
    tsserver = {
      filetypes = { "typescript", "javascript" },
      -- Root directory patterns specific to Pulumi TypeScript projects
      root_dir = function(fname)
        local is_pulumi = require("lspconfig").util.root_pattern("Pulumi.yaml", "Pulumi.yml")(fname)
        if is_pulumi then
          return is_pulumi
        end
        return require("lspconfig").util.root_pattern("tsconfig.json", "package.json", ".git")(fname)
      end,
      settings = {
        -- TypeScript settings optimized for Pulumi
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true
          }
        }
      }
    },
    
    -- Python for Pulumi Python
    pyright = {
      filetypes = { "python" },
      -- Root directory patterns specific to Pulumi Python projects
      root_dir = function(fname)
        local is_pulumi = require("lspconfig").util.root_pattern("Pulumi.yaml", "Pulumi.yml")(fname)
        if is_pulumi then
          return is_pulumi
        end
        return require("lspconfig").util.root_pattern("pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git")(fname)
      end
    },
    
    -- Go for Pulumi Go
    gopls = {
      filetypes = { "go", "gomod" },
      -- Root directory patterns specific to Pulumi Go projects
      root_dir = function(fname)
        local is_pulumi = require("lspconfig").util.root_pattern("Pulumi.yaml", "Pulumi.yml")(fname)
        if is_pulumi then
          return is_pulumi
        end
        return require("lspconfig").util.root_pattern("go.mod", ".git")(fname)
      end
    },
    
    -- YAML for Pulumi YAML
    yamlls = {
      filetypes = { "yaml", "yaml.pulumi" },
      settings = {
        yaml = {
          schemas = {
            -- Pulumi YAML schema
            ["https://raw.githubusercontent.com/pulumi/pulumi/master/pkg/codegen/schema/pulumi.json"] = {
              "Pulumi.yaml",
              "Pulumi.yml",
              "*.pulumi.yaml",
              "*.pulumi.yml"
            }
          }
        }
      },
      -- Filetype detection for Pulumi YAML files
      on_attach = function(client, bufnr)
        local filename = vim.fn.expand("%:t")
        if filename:match("^Pulumi%.") or filename:match("%.pulumi%.ya?ml$") then
          vim.bo[bufnr].filetype = "yaml.pulumi"
        end
      end
    }
  },
  
  -- Linters and formatters (requires none-ls)
  linters = {
    -- Pulumi preview as a "linter" to catch errors
    pulumi_preview = {
      filetypes = { "typescript", "python", "go", "yaml.pulumi" },
      source_type = "diagnostics",
      config = {
        command = "pulumi",
        args = { "preview", "--diff", "--non-interactive" },
        to_stdin = false,
        format = "line",
        check_exit_code = function(code)
          return code ~= 0
        end,
        cwd = function(params)
          -- Find the pulumi project root
          local cwd = params.bufname and vim.fn.fnamemodify(params.bufname, ":h") or vim.fn.getcwd()
          local pulumi_dir = require("lspconfig").util.root_pattern("Pulumi.yaml", "Pulumi.yml")(cwd)
          return pulumi_dir or cwd
        end,
        -- Custom parser for pulumi preview output
        on_output = function(params, done)
          -- Parse the pulumi preview output for errors
          -- This would need a custom implementation
          local diagnostics = {}
          -- ... implement diagnostics parsing ...
          return diagnostics
        end
      }
    }
  }
}
