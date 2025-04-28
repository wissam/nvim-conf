-- lua/lsp/configs/hcl.lua
return {
  -- LSP servers for HCL (HashiCorp Configuration Language)
  servers = {
    -- HCL Language Server
    hls = {
      filetypes = { "hcl", "terraform", "tf", "terraform-vars", "tfvars" },
      -- Root directory patterns
      root_dir = function(fname)
        return require("lspconfig").util.root_pattern("*.hcl", ".hcl", ".git")(fname) or
               require("lspconfig").util.find_git_ancestor(fname)
      end,
      settings = {
        hcl = {
          formatter = {
            enabled = true,
            indentSize = 2
          },
          validate = true
        }
      }
    },
    
    -- Nomad Language Server (if available)
    nomad_ls = {
      filetypes = { "hcl.nomad", "nomad" },
      -- Ensure server is available
      enabled = function()
        return vim.fn.executable("nomad") == 1
      end,
      -- Root directory patterns
      root_dir = function(fname)
        return require("lspconfig").util.root_pattern("*.nomad", ".nomad")(fname) or
               require("lspconfig").util.find_git_ancestor(fname)
      end,
      -- Special filetype detection for Nomad files
      on_attach = function(client, bufnr)
        local filename = vim.fn.expand("%:t")
        if filename:match("%.nomad$") then
          vim.bo[bufnr].filetype = "hcl.nomad"
        else
          -- Check content for Nomad job patterns
          local content = vim.api.nvim_buf_get_lines(bufnr, 0, 10, false)
          for _, line in ipairs(content) do
            if line:match("job%s+['\"]") then
              vim.bo[bufnr].filetype = "hcl.nomad"
              break
            end
          end
        end
      end
    },
    
    -- Vault Language Server (if available)
    vault_ls = {
      filetypes = { "hcl.vault", "vault" },
      -- Ensure server is available
      enabled = function()
        return vim.fn.executable("vault") == 1
      end,
      -- Root directory patterns
      root_dir = function(fname)
        return require("lspconfig").util.root_pattern("*.vault", ".vault")(fname) or
               require("lspconfig").util.find_git_ancestor(fname)
      end,
      -- Special filetype detection for Vault files
      on_attach = function(client, bufnr)
        local filename = vim.fn.expand("%:t")
        if filename:match("%.vault%.hcl$") then
          vim.bo[bufnr].filetype = "hcl.vault"
        else
          -- Check content for Vault patterns
          local content = vim.api.nvim_buf_get_lines(bufnr, 0, 10, false)
          for _, line in ipairs(content) do
            if line:match("path%s+['\"]") or line:match("secret%s+['\"]") then
              vim.bo[bufnr].filetype = "hcl.vault"
              break
            end
          end
        end
      end
    },
    
    -- Packer Language Server (if available)
    packer_ls = {
      filetypes = { "hcl.packer", "packer" },
      -- Ensure server is available
      enabled = function()
        return vim.fn.executable("packer") == 1
      end,
      -- Root directory patterns
      root_dir = function(fname)
        return require("lspconfig").util.root_pattern("*.pkr.hcl", "*.packer.hcl")(fname) or
               require("lspconfig").util.find_git_ancestor(fname)
      end,
      -- Special filetype detection for Packer files
      on_attach = function(client, bufnr)
        local filename = vim.fn.expand("%:t")
        if filename:match("%.pkr%.hcl$") or filename:match("%.packer%.hcl$") then
          vim.bo[bufnr].filetype = "hcl.packer"
        end
      end
    }
  },
  
  -- Linters and formatters (requires none-ls)
  linters = {
    -- HCL formatting
    hclfmt = {
      filetypes = { "hcl", "hcl.nomad", "hcl.vault", "hcl.packer" },
      source_type = "formatting",
      config = {}
    },
    
    -- Nomad validate (if available)
    nomad_validate = {
      filetypes = { "hcl.nomad", "nomad" },
      source_type = "diagnostics",
      config = {
        command = "nomad",
        args = { "job", "validate", "-" },
        to_stdin = true,
        format = "line",
        check_exit_code = function(code)
          return code ~= 0
        end,
        on_output = function(params, done)
          -- ... implement Nomad validate output parsing ...
          return {}
        end
      }
    },
    
    -- Vault validate (if available)
    vault_validate = {
      filetypes = { "hcl.vault", "vault" },
      source_type = "diagnostics",
      config = {
        command = "vault",
        args = { "validate", "-" },
        to_stdin = true,
        format = "line",
        check_exit_code = function(code)
          return code ~= 0
        end,
        on_output = function(params, done)
          -- ... implement Vault validate output parsing ...
          return {}
        end
      }
    },
    
    -- Packer validate (if available)
    packer_validate = {
      filetypes = { "hcl.packer", "packer" },
      source_type = "diagnostics",
      config = {
        command = "packer",
        args = { "validate", "-" },
        to_stdin = true,
        format = "line",
        check_exit_code = function(code)
          return code ~= 0
        end,
        on_output = function(params, done)
          -- ... implement Packer validate output parsing ...
          return {}
        end
      }
    }
  }
}
