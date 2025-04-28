-- lua/lsp/configs/kubernetes.lua
return {
  -- LSP servers for Kubernetes
  servers = {
    -- Kubernetes Language Server
    yamlls = {
      filetypes = { "yaml", "yaml.kubernetes" },
      settings = {
        yaml = {
          schemas = {
            ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = {
              "/*-k8s.yaml",
              "/*.k8s.yaml",
              "/*-k8s.yml",
              "/*.k8s.yml",
              "/*-kubernetes.yaml",
              "/*.kubernetes.yaml",
              "/*-kubernetes.yml",
              "/*.kubernetes.yml",
              "/deployment.yaml",
              "/service.yaml",
              "/ingress.yaml",
              "/configmap.yaml",
              "/secret.yaml"
            },
          },
          format = {
            enable = true,
          },
          validate = true,
          completion = true,
        }
      },
      -- Special filetype detection for Kubernetes YAML files
      on_attach = function(client, bufnr)
        -- If file contains Kubernetes keywords, set filetype to yaml.kubernetes
        if vim.bo[bufnr].filetype == "yaml" then
          local content = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
          for _, line in ipairs(content) do
            if line:match("apiVersion:") or line:match("kind:") then
              vim.bo[bufnr].filetype = "yaml.kubernetes"
              break
            end
          end
        end
      end
    },
    
    -- Kubectl Language Server (optional)
    -- This is another language server specifically for kubectl
    kubectl = {
      filetypes = { "yaml.kubernetes" },
      enabled = function()
        return vim.fn.executable("kubectl-language-server") == 1
      end
    }
  },
  
  -- Linters and formatters (requires none-ls)
  linters = {
    -- kubeval for validating Kubernetes manifests
    kubeval = {
      filetypes = { "yaml", "yaml.kubernetes" },
      source_type = "diagnostics",
      config = {
        -- Display additional information about the error
        extra_args = { "--strict" }
      }
    },
    
    -- kubeconform as a faster alternative to kubeval
    kubeconform = {
      filetypes = { "yaml", "yaml.kubernetes" },
      source_type = "diagnostics",
      config = {
        extra_args = { "-strict" }
      }
    },
    
    -- yamlfmt for formatting YAML
    yamlfmt = {
      filetypes = { "yaml", "yaml.kubernetes" },
      source_type = "formatting",
      config = {}
    }
  }
}
