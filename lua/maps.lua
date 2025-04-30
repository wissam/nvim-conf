-- Disabling some keys
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<Tab>', '<Nop>', { silent = true })

-- Remap k and j for word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Severity-specific diagnostic navigation keymaps
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
-- Keep only the specialized diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
vim.keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
vim.keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
vim.keymap.set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
vim.keymap.set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- Buffers keymaps
vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", {
  desc = "Prev buffer",
})

vim.keymap.set("n", "]b", "<cmd>bnext<cr>", {
  desc = "Next buffer",
})
