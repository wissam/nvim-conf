-- lua/lsp/configs/config_mgmt.lua
return {
  -- LSP servers for configuration management tools
  servers = {
    -- Salt Language Server
    salt_ls = {
      filetypes = { "sls", "salt", "yaml.salt" },
      -- Check if server is available
      enabled = function()
        return vim.fn.executable("salt-lint") == 1
      end,
      -- Root directory patterns
      root_dir = function(fname)
        return require("lspconfig").util.root_pattern(
          "*.sls",
          "salt/",
          "srv/salt/",
          "states/",
          "pillar/"
        )(fname)
      end,
      -- Filetype detection for Salt files
      on_attach = function(client, bufnr)
        local filename = vim.fn.expand("%:t")
        if filename:match("%.sls$") then
          vim.bo[bufnr].filetype = "sls"
        end
      end
    },
    
    -- Chef Language Server (Ruby + ERB)
    solargraph = {
      filetypes = { "ruby", "eruby", "chef" },
      -- Root directory patterns specific to Chef
      root_dir = function(fname)
        local is_chef = require("lspconfig").util.root_pattern(
          "Berksfile",
          "cookbooks/",
          "recipes/",
          "kitchen.yml",
          "metadata.rb"
        )(fname)
        if is_chef then
          return is_chef
        end
        return require("lspconfig").util.root_pattern("Gemfile", ".git")(fname)
      end,
      -- Filetype detection for Chef files
      on_attach = function(client, bufnr)
        local filepath = vim.fn.expand("%:p")
        if filepath:match("cookbooks/.+/recipes/.+%.rb$") or 
           filepath:match("cookbooks/.+/attributes/.+%.rb$") or
           filepath:match("cookbooks/.+/resources/.+%.rb$") then
          vim.bo[bufnr].filetype = "chef"
        end
      end
    },
    
    -- Puppet Language Server
    puppet = {
      filetypes = { "puppet" },
      -- Root directory patterns
      root_dir = function(fname)
        return require("lspconfig").util.root_pattern(
          "manifests/",
          "modules/",
          "site.pp",
          "hiera.yaml",
          "environment.conf"
        )(fname)
      end
    }
  },
  
  -- Linters and formatters (requires none-ls)
  linters = {
    -- Salt linting
    salt_lint = {
      filetypes = { "sls", "salt", "yaml.salt" },
      source_type = "diagnostics",
      config = {
        command = "salt-lint",
        args = { "--json", "-" },
        to_stdin = true,
        format = "json",
        check_exit_code = function(code)
          return code ~= 0
        end,
        on_output = function(params)
          -- Parse salt-lint JSON output
          local diagnostics = {}
          if params.output then
            local issues = vim.json.decode(params.output)
            if issues and #issues > 0 then
              for _, issue in ipairs(issues) do
                table.insert(diagnostics, {
                  row = issue.linenumber,
                  col = 1,
                  message = issue.message,
                  code = issue.id,
                  severity = 2, -- Warning
                  source = "salt-lint"
                })
              end
            end
          end
          return diagnostics
        end
      }
    },
    
    -- Rubocop for Chef files
    rubocop = {
      filetypes = { "ruby", "chef" },
      source_type = "diagnostics",
      config = {
        command = "rubocop",
        args = { "--format", "json", "--force-exclusion", "--stdin", "%filepath" },
        to_stdin = true,
        format = "json",
        -- Use Cookstyle for Chef files if available
        condition = function(utils)
          local filepath = vim.fn.expand("%:p")
          if filepath:match("cookbooks/.+/") and vim.fn.executable("cookstyle") == 1 then
            return false
          end
          return true
        end
      }
    },
    
    -- Cookstyle for Chef files
    cookstyle = {
      filetypes = { "chef", "ruby" },
      source_type = "diagnostics",
      config = {
        command = "cookstyle",
        args = { "--format", "json", "--force-exclusion", "--stdin", "%filepath" },
        to_stdin = true,
        format = "json",
        -- Only run on Chef files
        condition = function(utils)
          local filepath = vim.fn.expand("%:p")
          return filepath:match("cookbooks/.+/") ~= nil
        end
      }
    },
    
    -- Chef foodcritic linter
    foodcritic = {
      filetypes = { "chef", "ruby" },
      source_type = "diagnostics",
      config = {
        command = "foodcritic",
        args = { "%filepath" },
        to_temp_file = true,
        format = "line",
        check_exit_code = function(code)
          return code ~= 0
        end,
        -- Only run on Chef cookbook directories
        condition = function(utils)
          local filepath = vim.fn.expand("%:p")
          return filepath:match("cookbooks/.+/") ~= nil
        end
      }
    },
    
    -- Puppet linting
    puppet_lint = {
      filetypes = { "puppet" },
      source_type = "diagnostics",
      config = {
        command = "puppet-lint",
        args = { "--json", "--fix", "--relative" },
        to_temp_file = true,
        format = "json",
        check_exit_code = function(code)
          return code ~= 0
        end
      }
    }
  }
}
