vim.lsp.config('terraformls', {
  cmd = { 'terraform-lsp' },
  filetypes = { 'tf', 'tfstate', 'tfvars', 'hcl'},
  root_dir = require('lspconfig').util.root_pattern(
    '.git',
    'terraform.tfstate',
    'terraform.tfstate.backup',
    '.terraform',
    'main.tf',
    'variables.tf'
  ),
  settings = {
    terraform = {
      format = {
        enable = true,
      },
    },
  },
})
