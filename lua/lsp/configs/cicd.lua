-- lua/lsp/configs/cicd.lua
return {
  -- LSP servers for CI/CD configuration tools
  servers = {
    -- YAML for various CI/CD tools
    yamlls = {
      filetypes = { "yaml", "yaml.github-actions", "yaml.gitlab-ci", "yaml.circleci", "yaml.jenkins", "yaml.travis" },
      settings = {
        yaml = {
          schemas = {
            -- GitHub Actions workflow schema
            ["https://json.schemastore.org/github-workflow.json"] = {
              ".github/workflows/*.yml",
              ".github/workflows/*.yaml"
            },
            -- GitHub Actions action schema
            ["https://json.schemastore.org/github-action.json"] = {
              "action.yml",
              "action.yaml"
            },
            -- GitLab CI schema
            ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = {
              ".gitlab-ci.yml"
            },
            -- CircleCI schema
            ["https://json.schemastore.org/circleciconfig.json"] = {
              ".circleci/config.yml"
            },
            -- Azure Pipelines schema
            ["https://json.schemastore.org/azure-pipelines.json"] = {
              "azure-pipelines.yml",
              "azure-pipelines.yaml"
            },
            -- Travis CI schema
            ["https://json.schemastore.org/travis.json"] = {
              ".travis.yml"
            }
          }
        }
      },
      -- Filetype detection for CI/CD files
      on_attach = function(client, bufnr)
        local filename = vim.fn.expand("%:p")
        local filepath = string.lower(filename)
        
        -- GitHub Actions
        if filepath:match("%.github/workflows/.*%.ya?ml$") then
          vim.bo[bufnr].filetype = "yaml.github-actions"
        -- GitLab CI
        elseif filepath:match("%.gitlab%-ci%.ya?ml$") then
          vim.bo[bufnr].filetype = "yaml.gitlab-ci"
        -- CircleCI
        elseif filepath:match("%.circleci/config%.ya?ml$") then
          vim.bo[bufnr].filetype = "yaml.circleci"
        -- Azure Pipelines
        elseif filepath:match("azure%-pipelines%.ya?ml$") then
          vim.bo[bufnr].filetype = "yaml.azure-pipelines"
        -- Travis CI
        elseif filepath:match("%.travis%.ya?ml$") then
          vim.bo[bufnr].filetype = "yaml.travis"
        -- Jenkinsfile (yaml)
        elseif filepath:match("jenkinsfile%.ya?ml$") then
          vim.bo[bufnr].filetype = "yaml.jenkins"
        end
      end
    },
    
    -- Groovy for Jenkinsfile
    groovyls = {
      filetypes = { "groovy", "jenkinsfile" },
      -- Root directory patterns
      root_dir = function(fname)
        return require("lspconfig").util.root_pattern("Jenkinsfile", "jenkinsfile", ".git")(fname)
      end,
      -- Filetype detection for Jenkinsfile
      on_attach = function(client, bufnr)
        local filename = vim.fn.expand("%:t")
        if filename:match("^[Jj]enkinsfile$") then
          vim.bo[bufnr].filetype = "jenkinsfile"
        end
      end
    }
  },
  
  -- Linters and formatters (requires none-ls)
  linters = {
    -- GitHub Actions linting
    actionlint = {
      filetypes = { "yaml.github-actions" },
      source_type = "diagnostics",
      config = {
        command = "actionlint",
        args = { "-format", "{{json .}}", "-" },
        to_stdin = true,
        format = "json",
        check_exit_code = function(code)
          return code ~= 0
        end,
        on_output = function(params)
          -- Parse the actionlint JSON output
          local diagnostics = {}
          if params.output then
            local issues = vim.json.decode(params.output)
            if issues and #issues > 0 then
              for _, issue in ipairs(issues) do
                table.insert(diagnostics, {
                  row = issue.line,
                  col = issue.column,
                  message = issue.message,
                  severity = 2, -- Warning
                  source = "actionlint"
                })
              end
            end
          end
          return diagnostics
        end
      }
    },
    
    -- GitLab CI linting
    gitlab_ci_lint = {
      filetypes = { "yaml.gitlab-ci" },
      source_type = "diagnostics",
      config = {
        command = "gitlab-ci-lint",
        args = {},
        to_temp_file = true,
        format = "json",
        check_exit_code = function(code)
          return code ~= 0
        end
      }
    },
    
    -- CircleCI config validation
    circleci_validate = {
      filetypes = { "yaml.circleci" },
      source_type = "diagnostics",
      config = {
        command = "circleci",
        args = { "config", "validate", "-" },
        to_stdin = true,
        format = "line",
        check_exit_code = function(code)
          return code ~= 0
        end
      }
    },
    
    -- Jenkinsfile validation
    jenkins_validate = {
      filetypes = { "jenkinsfile", "groovy" },
      source_type = "diagnostics",
      config = {
        command = "jenkinsfile-linter",
        args = {},
        to_temp_file = true,
        format = "line",
        check_exit_code = function(code)
          return code ~= 0
        end
      }
    },
    
    -- Prettier for GitHub Actions files
    prettier = {
      filetypes = { "yaml.github-actions", "yaml.gitlab-ci", "yaml.circleci", "yaml.travis" },
      source_type = "formatting",
      config = {
        command = "prettier",
        args = { "--parser", "yaml" },
        to_stdin = true
      }
    }
  }
}
