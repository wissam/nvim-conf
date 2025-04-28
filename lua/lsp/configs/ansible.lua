-- lua/lsp/configs/ansible.lua
return {
  -- LSP servers for Ansible
  servers = {
    -- Ansible Language Server
    ansiblels = {
      filetypes = { "yaml.ansible", "ansible", "ansible_hosts" },
      -- Configure file patterns to identify as Ansible files
      pattern = { "*.yml", "*.yaml" },
      -- Initialize with your preferred settings
      settings = {
        ansible = {
          ansible = {
            path = "ansible",  -- Path to ansible executable
          },
          ansibleLint = {
            enabled = true,
            path = "ansible-lint", -- Path to ansible-lint executable
          },
          python = {
            interpreterPath = "python3", -- Path to python
          },
          validation = {
            enabled = true,
            lint = {
              enabled = true,
              path = "ansible-lint" 
            }
          },
          completion = {
            provideRedirectModules = true,
            provideModuleOptionAliases = true
          }
        }
      },
      -- Root directory patterns for Ansible projects
      root_dir = function(fname)
        return require("lspconfig").util.root_pattern(
          "ansible.cfg",
          ".ansible.cfg",
          "galaxy.yml",
          "roles/",
          "playbooks/",
          "inventories/"
        )(fname)
      end,
      -- Special filetype detection for Ansible YAML files
      -- Requires setting up autocmd for detection in your main config
      on_attach = function(client, bufnr)
        -- If you need to detect YAML files as ansible
        if vim.bo[bufnr].filetype == "yaml" then
          -- Check for ansible patterns
          local content = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
          for _, line in ipairs(content) do
            if line:match("hosts:") or line:match("tasks:") or line:match("roles:") then
              vim.bo[bufnr].filetype = "yaml.ansible"
              break
            end
          end
        end
      end
    }
  },
  
  -- Linters and formatters (requires none-ls)
  linters = {
    -- ansible-lint for linting Ansible playbooks
    ansible_lint = {
      filetypes = { "yaml.ansible", "ansible" },
      source_type = "diagnostics",
      config = {
        -- Additional arguments for ansible-lint
        extra_args = { "-c", ".ansible-lint" } -- Use .ansible-lint config if present
      }
    },
    
    -- Prettier with Ansible plugin for formatting
    prettier = {
      filetypes = { "yaml.ansible", "ansible" },
      source_type = "formatting",
      config = {
        extra_args = { 
          "--parser", "yaml",
          "--plugin", "prettier-plugin-ansible"
        },
        -- Only run if prettier-plugin-ansible is installed
        condition = function()
          return vim.fn.executable("prettier") == 1 and
                 vim.fn.executable("npm") == 1 and
                 vim.fn.system("npm list -g prettier-plugin-ansible") ~= ""
        end
      }
    },
    
    -- yamlfmt as an alternative formatter
    yamlfmt = {
      filetypes = { "yaml", "yaml.ansible", "ansible" },
      source_type = "formatting",
      config = {}
    }
  }
}
