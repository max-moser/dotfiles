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

        -- `cmp` needs to be set up after `lsp-zero`
        local cmp = require("cmp")
        cmp.setup({
            mapping = {
                -- allow `Enter` and `Tab` to confirm completion
                ["<CR>"] = cmp.mapping.confirm({select = false, behavior = cmp.ConfirmBehavior.Replace}),
                ["<Tab>"] = cmp.mapping.confirm({select = false, behavior = cmp.ConfirmBehavior.Replace}),

                -- `Ctrl-Space` to trigger completion menu
                ["<C-Space>"] = cmp.mapping.complete(),
            },
            completion = {
                completeopt = "menu,menuone,noinsert"
            }
        })
    end,
}
