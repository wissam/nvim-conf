-- after/plugin/lsp.rc.lua
local ok, lspconfig = pcall(require, "lspconfig")
if not ok then
  return
end

-- Try to load none-ls for linters
local none_ls_ok, none_ls = pcall(require, "none-ls")
local has_none_ls = none_ls_ok and none_ls

-- Base capabilities for all servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { "documentation", "detail", "additionalTextEdits" }
}

-- Common on_attach function for all servers
local on_attach = function(client, bufnr)
  -- Key mappings
  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, opts)
  vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
  
  -- Set autocommands conditional on server capabilities
  if client.server_capabilities.documentHighlightProvider then
    local highlight_group = vim.api.nvim_create_augroup("LspDocumentHighlight_" .. bufnr, { clear = true })
    vim.api.nvim_create_autocmd("CursorHold", {
      callback = vim.lsp.buf.document_highlight,
      group = highlight_group,
      buffer = bufnr,
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      callback = vim.lsp.buf.clear_references,
      group = highlight_group,
      buffer = bufnr,
    })
  end
end

-- Dynamically find LSP configs
local function get_lsp_configs()
  local configs = {}
  local lsp_config_path = vim.fn.stdpath("config") .. "/lua/lsp/configs"
  
  -- Get list of config files
  local config_files = vim.fn.glob(lsp_config_path .. "/*.lua", false, true)
  
  -- Create server to filetypes mapping
  for _, file in ipairs(config_files) do
    local server = vim.fn.fnamemodify(file, ":t:r")
    local status, config = pcall(require, "lsp.configs." .. server)
    
    if status and type(config) == "table" then
      -- Handle modern config format with servers and linters
      if config.servers or config.linters then
        configs[server] = config
      else
        -- Handle legacy config format (assume it's a server config)
        -- If config doesn't specify filetypes, add default filetypes for common servers
        if not config.filetypes then
          if server == "lua_ls" then
            config.filetypes = { "lua" }
          elseif server == "pyright" then
            config.filetypes = { "python" }
          elseif server == "tsserver" then
            config.filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" }
          elseif server == "rust_analyzer" then
            config.filetypes = { "rust" }
          elseif server == "gopls" then
            config.filetypes = { "go", "gomod", "gowork", "gotmpl" }
          elseif server == "terraformls" then
            config.filetypes = { "terraform", "tf", "terraform-vars", "tfvars" }
          elseif server == "clangd" then
            config.filetypes = { "c", "cpp", "objc", "objcpp" }
          end
        end
        
        if config.filetypes then
          configs[server] = { servers = { [server] = config } }
        end
      end
    end
  end
  
  -- Ensure lua_ls is included with default config if not found
  if not configs["lua"] and vim.fn.executable("lua-language-server") == 1 then
    configs["lua"] = {
      servers = {
        lua_ls = {
          filetypes = { "lua" },
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = { library = vim.api.nvim_get_runtime_file("", true) },
              telemetry = { enable = false }
            }
          }
        }
      }
    }
  end
  
  return configs
end

-- Build filetype to server and linter mapping
local function build_filetype_map(configs)
  local filetype_map = {}
  
  for config_name, config in pairs(configs) do
    -- Handle servers
    if config.servers then
      for server_name, server_config in pairs(config.servers) do
        if type(server_config.filetypes) == "table" then
          for _, ft in ipairs(server_config.filetypes) do
            if not filetype_map[ft] then
              filetype_map[ft] = { servers = {}, linters = {} }
            elseif not filetype_map[ft].servers then
              filetype_map[ft].servers = {}
            end
            
            table.insert(filetype_map[ft].servers, {
              name = server_name,
              config = server_config
            })
          end
        end
      end
    end
    
    -- Handle linters if none-ls is available
    if has_none_ls and config.linters then
      for linter_name, linter_config in pairs(config.linters) do
        if type(linter_config.filetypes) == "table" then
          for _, ft in ipairs(linter_config.filetypes) do
            if not filetype_map[ft] then
              filetype_map[ft] = { servers = {}, linters = {} }
            elseif not filetype_map[ft].linters then
              filetype_map[ft].linters = {}
            end
            
            table.insert(filetype_map[ft].linters, {
              name = linter_name,
              config = linter_config
            })
          end
        end
      end
    end
  end
  
  return filetype_map
end

-- Get all LSP configs and build the filetype map
local lsp_configs = get_lsp_configs()
local filetype_map = build_filetype_map(lsp_configs)

-- Set up none-ls if available
if has_none_ls then
  -- Create a set of sources
  local sources = {}
  
  -- Extract linter configurations and convert to sources
  for _, config in pairs(lsp_configs) do
    if config.linters then
      for linter_name, linter_config in pairs(config.linters) do
        -- Here we need to map linter names to sources
        local source_type = linter_config.source_type or "diagnostics" -- default to diagnostics
        
        if none_ls.builtins[source_type] and none_ls.builtins[source_type][linter_name] then
          local source = none_ls.builtins[source_type][linter_name]
          
          -- Apply any config options
          if linter_config.config then
            source = source.with(linter_config.config)
          end
          
          table.insert(sources, source)
        end
      end
    end
  end
  
  -- Setup none-ls
  none_ls.setup({
    sources = sources,
    on_attach = on_attach
  })
end

-- Set up LSP servers using vim.lsp.config for Neovim 0.11+
for config_name, config in pairs(lsp_configs) do
  if config.servers then
    for server_name, server_config in pairs(config.servers) do
      -- Create base config with capabilities and on_attach
      local lsp_config = {
        capabilities = capabilities,
        on_attach = on_attach
      }
      
      -- Copy over server settings while preserving filetypes for our mapping
      for k, v in pairs(server_config) do
        if k ~= "on_attach" then
          lsp_config[k] = v
        end
      end
      
      -- Custom on_attach handling
      if server_config.on_attach then
        local user_on_attach = lsp_config.on_attach
        lsp_config.on_attach = function(client, bufnr)
          user_on_attach(client, bufnr)
          server_config.on_attach(client, bufnr)
        end
      end
      
      -- Configure using the new Neovim 0.11+ API
      vim.lsp.config(server_name, lsp_config)
    end
  end
end

-- Attach LSP servers and linters dynamically based on filetype
local lsp_group = vim.api.nvim_create_augroup("LspDynamicSetup", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = lsp_group,
  callback = function(args)
    local ft = args.match
    local bufnr = args.buf
    
    -- Special case handling for specific filetypes
    if ft == "go" then
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(bufnr) then
          vim.lsp.enable("gopls", { bufnr = bufnr })
        end
      end)
    elseif (ft == "terraform" or ft == "tf" or ft == "tfvars") then
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(bufnr) then
          vim.lsp.enable("terraformls", { bufnr = bufnr })
        end
      end)
    end
    
    -- Handle other filetypes via the map
    if not filetype_map[ft] then return end
    
    -- Attach LSP servers
    if filetype_map[ft].servers then
      for _, server_info in ipairs(filetype_map[ft].servers) do
        local server_name = server_info.name
        
        -- Check if server is already attached
        local attached = false
        for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
          if client.name == server_name then 
            attached = true 
            break
          end
        end
        
        if not attached then
          -- Use the new vim.lsp.enable API
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(bufnr) then
              vim.lsp.enable(server_name, { bufnr = bufnr })
            end
          end)
        end
      end
    end
    
    -- Null-ls is automatically attached when the buffer is opened,
    -- as long as the filetype matches a registered source
  end
})

-- Add commands for debugging and diagnostics
vim.api.nvim_create_user_command("LspAttach", function()
  local ft = vim.bo.filetype
  local bufnr = vim.api.nvim_get_current_buf()
  
  if filetype_map[ft] and filetype_map[ft].servers then
    for _, server_info in ipairs(filetype_map[ft].servers) do
      vim.lsp.enable(server_info.name, { bufnr = bufnr })
    end
  elseif ft == "go" then
    vim.lsp.enable("gopls", { bufnr = bufnr })
  elseif (ft == "terraform" or ft == "tf" or ft == "tfvars") then
    vim.lsp.enable("terraformls", { bufnr = bufnr })
  end
  
  vim.cmd("LspInfo")
end, {})

vim.api.nvim_create_user_command("LspDebug", function()
  local ft = vim.bo.filetype
  local bufnr = vim.api.nvim_get_current_buf()
  
  print("Current filetype: " .. ft)
  
  if filetype_map[ft] then
    if filetype_map[ft].servers and #filetype_map[ft].servers > 0 then
      print("LSP servers mapped to this filetype:")
      for _, server_info in ipairs(filetype_map[ft].servers) do
        print("  - " .. server_info.name)
      end
    else
      print("No LSP servers mapped to this filetype")
    end
    
    if has_none_ls and filetype_map[ft].linters and #filetype_map[ft].linters > 0 then
      print("Linters mapped to this filetype:")
      for _, linter_info in ipairs(filetype_map[ft].linters) do
        print("  - " .. linter_info.name)
      end
    end
  elseif ft == "go" then
    print("Go filetype detected")
  elseif ft == "terraform" or ft == "tf" or ft == "tfvars" then
    print("Terraform filetype detected")
  else
    print("No servers or linters mapped to filetype: " .. ft)
  end
  
  -- Show active clients
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  if #clients > 0 then
    print("Active LSP clients for this buffer:")
    for _, client in ipairs(clients) do
      print("  - " .. client.name)
    end
  else
    print("No active LSP clients for this buffer")
  end
end, {})

-- Force the filetype for Terraform files
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = {"*.tf", "*.tfvars", "*.hcl"},
  callback = function()
    vim.bo.filetype = "terraform"
  end
})

-- Optional diagnostic configuration
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded", source = "always" }
})
