return {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    dependencies = {
        {"neovim/nvim-lspconfig"},
        {"folke/neodev.nvim"},

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
        local lsp_zero = require("lsp-zero")
        lsp_zero.on_attach(function(client, buf)
            lsp_zero.default_keymaps({buffer = buf})

            local map = function (mode, keys, func, desc)
                vim.keymap.set(mode, keys, func, { buffer = buf, desc = "LSP: " .. desc })
            end

            -- utilize telescope to improve code navigation hotkeys
            map("n", "gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
            map("n", "gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
            map("i", "<C-S-Space>", vim.lsp.buf.signature_help, "Signature Help")
        end)

        -- `neodev` takes care of setting up the Lua LS for neovim,
        -- needs to be set up before `lspconfig`
        require("neodev").setup({})
        require("mason").setup({})
        require("mason-lspconfig").setup({
            ensure_installed = {},
            handlers = { lsp_zero.default_setup }
        })

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
