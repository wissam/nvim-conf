-- lua/lsp/configs/aws.lua
return {
  -- LSP servers for AWS technologies
  servers = {
    -- AWS CloudFormation Linter Language Server
    cfn_ls = {
      filetypes = { "yaml.cloudformation", "json.cloudformation" },
      settings = {
        cfnLint = {
          format = true,
          validateOnSave = true,
          path = "cfn-lint"
        }
      },
      -- Root directory patterns
      root_dir = function(fname)
        return require("lspconfig").util.root_pattern(
          "*.template",
          "*.template.yaml", 
          "*.template.json",
          "*.cloudformation.yaml",
          "*.cloudformation.json",
          "cdk.json",
          "samconfig.toml"
        )(fname)
      end,
      -- Special filetype detection for CloudFormation files
      on_attach = function(client, bufnr)
        local filename = vim.fn.expand("%:t")
        -- Detect CloudFormation files
        if filename:match("%.template%.") or filename:match("%.cloudformation%.") then
          local ext = vim.fn.fnamemodify(filename, ":e")
          if ext == "yaml" or ext == "yml" then
            vim.bo[bufnr].filetype = "yaml.cloudformation"
          elseif ext == "json" then
            vim.bo[bufnr].filetype = "json.cloudformation"
          end
        else
          -- Check content for CloudFormation patterns
          local content = vim.api.nvim_buf_get_lines(bufnr, 0, 10, false)
          for _, line in ipairs(content) do
            if line:match("AWSTemplateFormatVersion") or line:match("Resources:") and line:match("Type:") then
              local ext = vim.fn.fnamemodify(filename, ":e")
              if ext == "yaml" or ext == "yml" then
                vim.bo[bufnr].filetype = "yaml.cloudformation"
              elseif ext == "json" then
                vim.bo[bufnr].filetype = "json.cloudformation"
              end
              break
            end
          end
        end
      end
    },
    
    -- TypeScript support for AWS CDK
    tsserver = {
      filetypes = { "typescript" },
      -- Skip this if already configured in web.lua
      root_dir = function(fname)
        -- Additional check for CDK projects
        local is_cdk = require("lspconfig").util.root_pattern("cdk.json")(fname)
        if is_cdk then
          return is_cdk
        end
        return require("lspconfig").util.root_pattern("tsconfig.json", "package.json", ".git")(fname)
      end,
      settings = {
        -- Add AWS CDK specific settings if needed
      }
    },
    
    -- Python support for AWS CDK
    pyright = {
      filetypes = { "python" },
      -- Skip this if already configured in python.lua
      root_dir = function(fname)
        -- Additional check for CDK projects
        local is_cdk = require("lspconfig").util.root_pattern("cdk.json")(fname)
        if is_cdk then
          return is_cdk
        end
        return require("lspconfig").util.root_pattern("pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git")(fname)
      end,
      settings = {
        -- Add AWS CDK specific settings if needed
      }
    }
  },
  
  -- Linters and formatters (requires none-ls)
  linters = {
    -- cfn-lint for CloudFormation validation
    cfn_lint = {
      filetypes = { "yaml.cloudformation", "json.cloudformation" },
      source_type = "diagnostics",
      config = {
        command = "cfn-lint",
        args = { "--format", "parseable", "-" },
        -- This is a custom parser for cfn-lint output
        on_output = function(params, done)
          local diagnostics = {}
          -- ... implement cfn-lint output parsing ...
          return diagnostics
        end
      }
    },
    
    -- SAM validator
    sam_validate = {
      filetypes = { "yaml.cloudformation" },
      source_type = "diagnostics",
      config = {
        command = "sam",
        args = { "validate", "--debug" },
        to_stdin = false,
        format = "raw",
        check_exit_code = function(code)
          return code ~= 0
        end,
        -- This requires custom parsing of SAM output
        on_output = function(_, stderr)
          -- ... implement SAM output parsing ...
          return {}
        end
      }
    },
    
    -- CDK specific linting (experimental)
    cdk_nag = {
      filetypes = { "typescript", "python" },
      source_type = "diagnostics",
      config = {
        -- Requires custom implementation based on how you've integrated cdk-nag
        -- This is just a placeholder
        command = "npm",
        args = { "run", "cdk-nag", "--silent" },
        to_stdin = false,
        format = "json",
        check_exit_code = function(code)
          return code ~= 0
        end,
        on_output = function(params, done)
          -- ... implement CDK nag output parsing ...
          return {}
        end
      }
    }
  }
}
