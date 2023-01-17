-----------------------------------------------
--globals
-----------------------------------------------

-- Remap space as leader key
vim.g.mapleader = ' '
vim.go.maplocalleader = ' '


-----------------------------------------------
--Options
-----------------------------------------------

--Set highlight 
vim.o.hlsearch = false
vim.o.incsearch = true

--Make line numbers and relative numbers
vim.wo.number = true
vim.wo.relativenumber = true

--Disable mouse mode
vim.o.mouse = nil
-- Seems now neovim has mouse enable by default since around July...

--Enable break indent
vim.o.breakindent = true

--Save undo history
vim.opt.undofile = true

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

--Decrease update time
vim.o.updatetime = 50
vim.wo.signcolumn = 'yes'

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Set folding to manual
vim.o.foldmethod = 'manual'

-- Set clipboard
vim.g.clipboard ='unnamedplus'

-- More options
vim.o.background = 'dark'
vim.o.autoread = true
vim.o.autowrite = true
vim.o.ruler = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.cursorline = true
vim.o.laststatus = 3
vim.o.encoding = 'utf-8'
vim.o.hidden = true
vim.o.cmdheight = 2
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.scrolloff = 8
vim.o.statuscolumn = true

-- Diagnostics Conf

