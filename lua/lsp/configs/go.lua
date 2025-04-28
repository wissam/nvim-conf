vim.lsp.config('gopls', {
  cmd = { 'gopls', 'serve' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  single_file_support = true,
  root_dir = function(fname)
    return vim.fs.dirname(vim.fs.find({ 'go.mod', '.git' }, { upward = true, path = fname })[1])
  end,
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        shadow = true,
      },
      staticcheck = true,
      gofumpt = true,
    },
  },
})


vim.lsp.config('golangci-lint-langserver', {
  cmd = { 'golangci-lint-langserver' },
  filetypes = { 'go' },
  root_dir = function(fname)
    return vim.fs.dirname(vim.fs.find({ 'go.mod', '.git' }, { upward = true, path = fname })[1])
  end,
  init_options = {
    command = 'golangci-lint',
    args = { 'run', '--out-format', 'json' },
  },
})
