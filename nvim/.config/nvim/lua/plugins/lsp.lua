local function setup_mason()
    -- tell mason how to set up the various language servers
    require("mason").setup({})
    require("mason-lspconfig").setup({
        ensure_installed = {},
        handlers = {
            -- if we want specific setup logic for individual language servers, we can register
            -- a function under the server's name here, e.g. `lua_ls = function() ... end,`
            function(lsp_name)
                -- next to capabilities, we could provide LSP-specific settings
                require("lspconfig")[lsp_name].setup({
                    capabilities = require("cmp_nvim_lsp").default_capabilities(),
                })
            end,
        },
    })
end

local function setup_cmp()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    cmp.setup({
        enabled = function()
            -- disable in 'prompt-buffer' (typically input for jobs)
            local disabled = (vim.api.nvim_get_option_value('buftype', { buf = 0 }) == 'prompt')

            -- disable when recording/executing recordings
            disabled = disabled or (vim.fn.reg_recording() ~= '')
            disabled = disabled or (vim.fn.reg_executing() ~= '')

            -- disable inside comments & strings
            disabled = disabled or require('cmp.config.context').in_treesitter_capture('comment')
            disabled = disabled or require('cmp.config.context').in_treesitter_capture('string_content')
            return not disabled
        end,
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
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
            -- but also use `Tab` and `Shift-Tab` for cycling through snippet spots
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
            keyword_length = 2,
        },
        experimental = {
            ghost_text = false,
        },
        sources = {
            -- see here for a curated list of sources:
            -- https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources
            { name = "nvim_lsp" },
            { name = "luasnip" },
        }
    })
end

return {
    -- default LSP configurations
    {
        "neovim/nvim-lspconfig"
    },

    -- mason for installing new language servers
    {
        "williamboman/mason.nvim",
        build = function()
            pcall(vim.cmd, "MasonUpdate")
        end,
        init = setup_mason,
    },
    {
        "williamboman/mason-lspconfig.nvim"
    },

    -- autocompletion
    {
        "hrsh7th/nvim-cmp",
        init = setup_cmp,
    },
    {
        "hrsh7th/cmp-nvim-lsp"
    },
    {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
    },
}
