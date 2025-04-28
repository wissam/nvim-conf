-- lua/lsp/configs/docker.lua
return {
  -- LSP servers for Docker
  servers = {
    -- Docker Language Server
    dockerls = {
      filetypes = { "dockerfile" },
      -- Root directory patterns
      root_dir = function(fname)
        return require("lspconfig").util.root_pattern("Dockerfile", ".docker", "docker-compose.yml", "docker-compose.yaml")(fname)
      end,
      -- Configuration options
      settings = {
        docker = {
          formatter = {
            ignoreMultilineInstructions = false,
          },
        }
      }
    },
    
    -- Docker Compose Language Server
    docker_compose_language_service = {
      filetypes = { "yaml.docker-compose" },
      -- Root directory patterns
      root_dir = function(fname)
        return require("lspconfig").util.root_pattern("docker-compose.yml", "docker-compose.yaml", "compose.yml", "compose.yaml")(fname)
      end,
      -- Special filetype detection
      on_attach = function(client, bufnr)
        local filename = vim.fn.expand("%:t")
        if filename:match("docker%-compose") or filename:match("compose%.yml") or filename:match("compose%.yaml") then
          vim.bo[bufnr].filetype = "yaml.docker-compose"
        end
      end
    }
  },
  
  -- Linters and formatters (requires none-ls)
  linters = {
    -- hadolint for Dockerfile linting
    hadolint = {
      filetypes = { "dockerfile" },
      source_type = "diagnostics",
      config = {
        -- Use .hadolint.yaml if available
      }
    },
    
    -- Compose validator
    docker_compose = {
      filetypes = { "yaml.docker-compose" },
      source_type = "diagnostics",
      config = {
        command = "docker",
        args = { "compose", "config", "--quiet" },
        to_stdin = false,
        format = "raw",
        check_exit_code = function(code, stderr)
          return code ~= 0
        end,
        on_output = function(_, stderr)
          if stderr and stderr ~= "" then
            local lines = vim.split(stderr, "\n")
            local diagnostics = {}
            
            for _, line in ipairs(lines) do
              if line:match("^ERROR:") then
                table.insert(diagnostics, {
                  message = line:gsub("^ERROR:%s*", ""),
                  severity = 1, -- Error
                  source = "docker-compose"
                })
              elseif line:match("^WARNING:") then
                table.insert(diagnostics, {
                  message = line:gsub("^WARNING:%s*", ""),
                  severity = 2, -- Warning
                  source = "docker-compose"
                })
              end
            end
            
            return diagnostics
          end
          return {}
        end
      }
    }
  }
}
