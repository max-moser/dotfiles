return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        init = function()
            -- register an autocommand for automatically starting treesitter for supported file types
            vim.api.nvim_create_autocmd("FileType", {
                desc = "Start Treesitter when using supported file types",
                callback = function(ev)
                    local ts = require("nvim-treesitter")
                    local filetype = ev.match

                    if vim.list_contains(ts.get_installed(), filetype) then
                        -- if the file is larger than 5 MiB, treesitter starts becoming too slow for nice UX
                        -- with more than 30 MiB, it starts becoming painful
                        local max_filesize = 5 * 1024 * 1024
                        local bytes = vim.fn.wordcount()["bytes"]

                        if bytes <= max_filesize then
                            if vim.opt.foldexpr:get() == "0" then
                                vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
                                vim.wo.foldmethod = "expr"
                            end

                            vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
                            vim.treesitter.start()

                            -- load the other treesitter plugins
                            require("nvim-treesitter-textobjects")
                            require("treesitter-context")
                        else
                            vim.treesitter.stop()
                        end
                    else
                        vim.treesitter.stop()
                    end
                end,
            })
        end,
    },
    {
        -- enhances selections and motions like [m with the power of treesitter
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        lazy = true,
        opts = {
            move = {
                set_jumps = true,
            },
            select = {
                include_surrounding_whitespace = false,
            },
        },
        init = function()
            local select = require("nvim-treesitter-textobjects.select")
            local move = require("nvim-treesitter-textobjects.move")
            local function map(mode, key_combo, command, opts)
                vim.keymap.set(mode, key_combo, command, opts)
            end

            -- hotkeys for selecting text objects
            map({ "x", "o" }, "ac", function()
                select.select_textobject("@class.outer", "textobjects")
            end)
            map({ "x", "o" }, "ic", function()
                select.select_textobject("@class.inner", "textobjects")
            end)
            map({ "x", "o" }, "am", function()
                select.select_textobject("@function.outer", "textobjects")
            end)
            map({ "x", "o" }, "im", function()
                select.select_textobject("@function.inner", "textobjects")
            end)
            map({ "x", "o" }, "as", function()
                select.select_textobject("@local.scope", "locals")
            end)

            -- hotkeys for jumping around text objects
            -- classes
            map({ "n", "x", "o" }, "[[", function()
                move.goto_previous_start("@class.outer", "textobjects")
            end)
            map({ "n", "x", "o" }, "]]", function()
                move.goto_next_start("@class.outer", "textobjects")
            end)
            map({ "n", "x", "o" }, "[]", function()
                move.goto_previous_end("@class.outer", "textobjects")
            end)
            map({ "n", "x", "o" }, "][", function()
                move.goto_next_end("@class.outer", "textobjects")
            end)

            -- functions
            map({ "n", "x", "o" }, "[m", function()
                move.goto_previous_start("@function.outer", "textobjects")
            end)
            map({ "n", "x", "o" }, "]m", function()
                move.goto_next_start("@function.outer", "textobjects")
            end)
            map({ "n", "x", "o" }, "[M", function()
                move.goto_previous_end("@function.outer", "textobjects")
            end)
            map({ "n", "x", "o" }, "]M", function()
                move.goto_next_end("@function.outer", "textobjects")
            end)

            -- if statements: jump to start or end, whichever is closer
            map({ "n", "x", "o" }, "]d", function()
                move.goto_next("@conditional.outer", "textobjects")
            end)
            map({ "n", "x", "o" }, "[d", function()
                move.goto_previous("@conditional.outer", "textobjects")
            end)

            -- loops
            map({ "n", "x", "o" }, "[o", function()
                move.goto_previous_start({ "@loop.inner", "@loop.outer" }, "textobjects")
            end)
            map({ "n", "x", "o" }, "]o", function()
                move.goto_next_start({ "@loop.inner", "@loop.outer" }, "textobjects")
            end)

            -- scopes
            map({ "n", "x", "o" }, "[s", function()
                move.goto_previous_start("@local.scope", "locals")
            end)
            map({ "n", "x", "o" }, "]s", function()
                move.goto_next_start("@local.scope", "locals")
            end)
        end,
    },
    {
        -- show context of the currently selected line (e.g. class, function) on the top of the screen
        "nvim-treesitter/nvim-treesitter-context",
        lazy = true,
        opts = {
            enable = true,
            multiwindow = false,
            line_numbers = false,
            separator = "▓",
        },
    },
}
