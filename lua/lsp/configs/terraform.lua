-- lua/lsp/configs/terraform.lua
return {
  -- LSP servers for Terraform
  servers = {
    -- Terraform Language Server
    terraformls = {
      filetypes = { "terraform", "tf", "terraform-vars", "tfvars", "hcl" },
      -- Root directory patterns - useful for monorepo setups
      root_dir = function(fname)
        return require("lspconfig").util.root_pattern(
          ".git",
          ".terraform",
          "terraform.tf",
          "main.tf",
          "*.tf"
        )(fname)
      end,
      -- Language server settings
      settings = {
        terraform = {
          -- Enable terraform-ls formatting capability
          format = {
            enable = true
          },
          -- Enable terraform validation via terraform-ls
          validation = {
            enable = true
          }
        }
      }
    },
    
    -- Optional: tflint for linting Terraform files
    tflint = {
      filetypes = { "terraform", "tf", "terraform-vars", "tfvars" },
      -- Initialization options
      init_options = {
        config = nil, -- Let tflint find the config file (.tflint.hcl)
        configPath = nil, -- Or specify explicit path if needed
      }
    }
  },
  
  -- Formatters (requires none-ls)
  linters = {
    -- Terraform fmt for code formatting
    terraform_fmt = {
      filetypes = { "terraform", "tf", "terraform-vars", "tfvars" },
      source_type = "formatting",
      config = {
        -- Terraform fmt doesn't need additional arguments usually
      }
    }
  }
}
