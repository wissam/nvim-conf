-- lua/lsp/configs/gcp.lua
return {
  -- LSP servers for GCP technologies
  servers = {
    -- YAML for GCP Deployment Manager
    yamlls = {
      filetypes = { "yaml", "yaml.gcp" },
      settings = {
        yaml = {
          schemas = {
            -- GCP deployment manager schema
            ["https://raw.githubusercontent.com/GoogleCloudPlatform/deploymentmanager-samples/master/schemas/deployment-manager.schema.yaml"] = {
              "*.deployment.yaml", 
              "*.deployment.yml",
              "deployment-manifest.yaml",
              "deployment-manifest.yml",
              "*.dm.yaml",
              "*.dm.yml"
            }
          }
        }
      },
      -- Filetype detection for GCP Deployment Manager files
      on_attach = function(client, bufnr)
        local filename = vim.fn.expand("%:t")
        if filename:match("%.deployment%.ya?ml$") or filename:match("%.dm%.ya?ml$") or filename:match("^deployment%-manifest%.ya?ml$") then
          vim.bo[bufnr].filetype = "yaml.gcp"
        else
          -- Check content for GCP deployment manager keywords
          local content = vim.api.nvim_buf_get_lines(bufnr, 0, 10, false)
          for _, line in ipairs(content) do
            if line:match("resources:") and line:match("type: gcp%-types/") then
              vim.bo[bufnr].filetype = "yaml.gcp"
              break
            end
          end
        end
      end
    },
    
    -- Python for GCP deployment templates
    pyright = {
      filetypes = { "python" },
      -- Root directory patterns
      root_dir = function(fname)
        local is_gcp_dm = require("lspconfig").util.root_pattern(
          "*.deployment.py",
          "*.deployment-config.py"
        )(fname)
        if is_gcp_dm then
          return is_gcp_dm
        end
        return require("lspconfig").util.root_pattern("pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git")(fname)
      end
    },
    
    -- Jinja2 for GCP templates
    jinja_ls = {
      filetypes = { "jinja", "jinja2", "jinja.html", "jinja.py" },
      -- Jinja2 LSP is experimental and may not be available
      enabled = function()
        return vim.fn.executable("jinja-language-server") == 1
      end
    }
  },
  
  -- Linters and formatters (requires none-ls)
  linters = {
    -- GCP specific YAML linting
    gcp_yamllint = {
      filetypes = { "yaml.gcp" },
      source_type = "diagnostics",
      config = {
        command = "yamllint",
        args = { "-f", "parsable", "-" },
        to_stdin = true,
        -- Custom config specifically for GCP YAML files
        extra_args = function()
          -- Check for GCP-specific yamllint config
          local config_path = vim.fn.expand("~/.config/yamllint/gcp-config.yaml")
          if vim.fn.filereadable(config_path) == 1 then
            return { "-c", config_path }
          end
          return {}
        end
      }
    },
    
    -- gcloud CLI validation
    gcloud_validate = {
      filetypes = { "yaml.gcp" },
      source_type = "diagnostics",
      config = {
        command = "gcloud",
        args = { "deployment-manager", "deployments", "validate", "--format=json" },
        to_temp_file = true,
        format = "json",
        check_exit_code = function(code)
          return code ~= 0
        end,
        -- Custom parser for gcloud output
        on_output = function(params)
          -- Parse the gcloud validate output
          -- This would need a custom implementation
          local diagnostics = {}
          -- ... implement diagnostics parsing ...
          return diagnostics
        end
      }
    },
    
    -- Python linting for GCP templates
    pylint = {
      filetypes = { "python" },
      source_type = "diagnostics",
      config = {
        -- Only run in GCP deployment manager Python files
        runtime_condition = function(params)
          return params.bufname:match("%.deployment%.py$") or
                 params.bufname:match("%-config%.py$") or
                 params.bufname:match("^template%.py$")
        end,
        -- Add GCP specific pylint plugins/rules
        extra_args = { "--load-plugins=pylint_gcp" }
      }
    }
  }
}
