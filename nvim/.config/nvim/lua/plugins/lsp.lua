return {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v2.x",
    dependencies = {
        {"neovim/nvim-lspconfig"},

        -- mason for installing new LSP servers
        {
            "williamboman/mason.nvim",
            build = function ()
                pcall(vim.cmd, "MasonUpdate")
            end,
        },
        {"williamboman/mason-lspconfig.nvim"},

        -- autocompletion
        -- TODO set up "supertab"
        {"hrsh7th/nvim-cmp"},
        {"hrsh7th/cmp-nvim-lsp"},
        {"L3MON4D3/LuaSnip"},
    },
    init = function()
        local lsp = require("lsp-zero").preset({})
        lsp.on_attach(function(client, buf)
            lsp.default_keymaps({buffer = buf})
        end)
        lsp.setup()
    end,
}
