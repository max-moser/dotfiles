return {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    dependencies = {
        { "neovim/nvim-lspconfig" },

        -- mason for installing new language servers
        {
            "williamboman/mason.nvim",
            build = function()
                pcall(vim.cmd, "MasonUpdate")
            end,
        },
        { "williamboman/mason-lspconfig.nvim" },

        -- autocompletion
        { "hrsh7th/nvim-cmp" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "L3MON4D3/LuaSnip" },
    },
    init = function()
        local lsp_zero = require("lsp-zero")
        lsp_zero.on_attach(function(client, buf)
            lsp_zero.default_keymaps({ buffer = buf })

            local map = function(mode, keys, func, desc)
                vim.keymap.set(mode, keys, func, { buffer = buf, desc = "LSP: " .. desc })
            end

            -- utilize telescope to improve code navigation hotkeys
            map("n", "gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
            map("n", "gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
            map("i", "<C-S-Space>", vim.lsp.buf.signature_help, "Signature Help")
        end)

        local lsp_zero_server = require("lsp-zero.server")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")

        require("mason").setup({})
        require("mason-lspconfig").setup({
            ensure_installed = {},
            handlers = {
                function(lsp_name)
                    -- slightly extended `lsp_zero.default_setup(lsp_name)`
                    lsp_zero_server.setup(lsp_name, {
                        capabilities = cmp_nvim_lsp.default_capabilities(),
                    })
                end,
            },
        })

        -- `cmp` needs to be set up after `lsp-zero`
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        cmp.setup({
            enabled = function ()
                -- disable in 'prompt-buffer' (typically input for jobs)
                local disabled = (vim.api.nvim_get_option_value('buftype', { buf = 0 }) == 'prompt')

                -- disable when recording/executing recordings
                disabled = disabled or (vim.fn.reg_recording() ~= '')
                disabled = disabled or (vim.fn.reg_executing() ~= '')

                -- disable inside comments
                disabled = disabled or require('cmp.config.context').in_treesitter_capture('comment')
                return not disabled
            end,
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                -- `Ctrl-Space` to trigger completion menu
                ["<C-Space>"] = cmp.mapping.complete(),

                -- scrolling the docs
                ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                ["<C-d>"] = cmp.mapping.scroll_docs(4),
                ["<C-k>"] = cmp.mapping.scroll_docs(-1),
                ["<C-j>"] = cmp.mapping.scroll_docs(1),

                -- allow `Enter` and `Tab` to confirm completion,
                -- but also use `Tab` and `Shift-Tab` for cycling through suggestions
                ["<CR>"] = cmp.mapping.confirm({ select = false, behavior = cmp.ConfirmBehavior.Replace }),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        -- if a suggestion is currently open, i want to accept it with `Tab`
                        cmp.confirm({ select = false, behavior = cmp.ConfirmBehavior.Replace })
                    elseif luasnip.expand_or_jumpable() then
                        -- if i'm still in a snippet, i want to jump to the next position
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),
            completion = {
                completeopt = "menu,menuone,noinsert",
            },
            experimental = {
                ghost_text = false,
            },
        })
    end,
}
