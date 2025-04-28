return {
    --Essentials
    {
        "tjdevries/colorbuddy.nvim",
    },
    {
        "numToStr/Comment.nvim",
    },
    {
        "ludovicchabant/vim-gutentags",
    },
    {
        "catppuccin/nvim",
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { 'nvim-tree/nvim-web-devicons' },
    },
    {
        "lukas-reineke/indent-blankline.nvim",
    },
    {
        "lewis6991/gitsigns.nvim",
        dependencies = { 'nvim-lua/plenary.nvim' },
    },
    {
        "folke/lazydev.nvim",
    },
    {
        "folke/trouble.nvim",
        dependencies = { 'nvim-tree/nvim-web-devicons'},
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xl",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xq",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
        },
    },
    {
        "kylechui/nvim-surround",
    },
    {
        "ellisonleao/glow.nvim",
    },
}

