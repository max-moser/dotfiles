-- ------------ --
-- autocommands --
-- ------------ --

-- jump to the last position when reopening a file
vim.api.nvim_create_autocmd("BufReadPost", {
    desc = "Jump to the last position when reopening a file",
    group = vim.api.nvim_create_augroup("last_location", { clear = true }),
    callback = function()
        local exclude = { "gitcommit" }
        local buffer = vim.api.nvim_get_current_buf()
        if vim.tbl_contains(exclude, vim.bo[buffer].filetype) then
            return
        end

        local mark = vim.api.nvim_buf_get_mark(buffer, '"')
        local line_count = vim.api.nvim_buf_line_count(buffer)
        if mark[1] > 0 and mark[1] < line_count then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- remap 'h' and 'l' to something useful in netrw
vim.api.nvim_create_autocmd("FileType", {
    desc = "Remap 'h' and 'l' to file system navigation in netrw",
    pattern = "netrw",
    group = vim.api.nvim_create_augroup("netrw_mappings", { clear = true }),
    callback = function()
        vim.api.nvim_buf_set_keymap(0, "", "h", "-", {})
        vim.api.nvim_buf_set_keymap(0, "", "l", "<CR>", {})
    end,
})

-- update folds (and close them) after opening a buffer
-- https://github.com/nvim-telescope/telescope.nvim/issues/699
vim.api.nvim_create_autocmd("BufEnter", {
    desc = "Update folds after opening a file",
    callback = function()
        if vim.opt.foldmethod:get() == "expr" then
            vim.schedule(function()
                vim.opt.foldmethod = "expr"
            end)
        end
    end,
})

-- set up some hotkeys that require a running LSP to work
-- vim.api.nvim_create_autocmd("LspAttach", {
--     desc = "LSP setup",
--     callback = function(event)
--         local opts = { buffer = event.buf }
--         local map = function(mode, keys, func, desc)
--             vim.keymap.set(mode, keys, func, { buffer = opts.buffer, desc = "LSP: " .. desc })
--         end
--
--         -- utilize telescope to improve code navigation hotkeys
--         map("n", "gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
--         map("n", "gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
--         map("i", "<C-S-Space>", "<Cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature Help")
--         map("n", "<F2>", "<Cmd>lua vim.lsp.buf.rename()<CR>", "Rename symbol")
--         map({ "n", "x" }, "<F3>", "<Cmd>lua vim.lsp.buf.format({async = true})<CR>", "Format code")
--         map("n", "<F4>", "<Cmd>lua vim.lsp.buf.code_action()<CR>", "Code action")
--     end,
-- })

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client ~= nil then
            local function map(mode, keys, func, desc)
                vim.keymap.set(mode, keys, func, { buffer = ev.buf, desc = "LSP: " .. desc })
            end

            if client:supports_method("textDocument/completion") then
                -- trigger autocomplete on every keypress
                local chars = {}
                for i = 32, 126 do
                    table.insert(chars, string.char(i))
                end
                client.server_capabilities.completionProvider.triggerCharacters = chars

                -- enable completion
                vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })

                -- map ^SPACE to manually trigger completion
                vim.keymap.set("i", "<C-Space>", function()
                    vim.lsp.completion.get()

                    -- TODO: this doesn't quite work, probably needs to go into an autocmd & have its :
                    -- e.g. vim.bo[args.buf].formatexpr = nil
                    -- local info = vim.fn.complete_info()
                    -- local pum_visible = info.pum_visible
                    -- local bufnr = info.preview_bufnr
                    -- if pum_visible == 1 and bufnr ~= nil then
                    --     vim.keymap.set("i", "<C-d>", "<C-e>", { buffer = bufnr, desc = "LSP: scroll docs" })
                    -- end
                end)

                -- auto-select first entry for quick tab but don't insert it as text yet
                -- vim.cmd[[set completeopt-=noselect]]
                -- vim.cmd[[set completeopt+=noinsert]]

                -- set some keymaps for the completion menu
                vim.keymap.set("i", "<Tab>", function()
                    return vim.fn.pumvisible() == 1 and "<C-y>" or "<Tab>"
                end, { expr = true })
                vim.keymap.set("i", "<C-j>", function()
                    return vim.fn.pumvisible() == 1 and "<C-n>" or "<C-j>"
                end, { expr = true })
                vim.keymap.set("i", "<C-k>", function()
                    return vim.fn.pumvisible() == 1 and "<C-p>" or "<C-j>"
                end, { expr = true })
                vim.keymap.set("i", "<C-Enter>", function()
                    return vim.fn.pumvisible() == 1 and "<C-o>o" or "<C-Enter>"
                end, { expr = true })

                -- :h compl-autocomplete
                -- TODO: discard snippet mode as soon as insert mode is left
                -- TODO: window border around completion popup docs
                --       [pumborder seems to affect the wrong thing :(]
                -- TODO: hotkeys to scroll in the popup docs
                --       [preview_bufnr can be obtained from complete_info(). Then you can create buffer-local keymaps for that buffer to handle scrolling.]
                -- TODO: exclude Text suggestions { => is this even a real issue? they don't seem to pop up in *actual* LSP suggestions, only if there are no proper suggestions }
                --
                -- DONE: show documentation of hovered item [works with cot+=popup in 0.12+]
                -- DONE: more keymaps (accept, abort, ...)
                -- DONE: disable completions in certain contexts (e.g. comments)
                --       [disabled in strings, enabled in comments but ok with cot+=noselect]

                -- from: https://github.com/neovim/neovim/issues/38248
                -- can be removed once the popup window respects the 'winborder' setting
                local function hack_border()
                    -- Add a rounded border to all LSP floating windows (hover, signature help)
                    -- local orig_open_floating_preview = vim.lsp.util.open_floating_preview
                    -- ---@diagnostic disable-next-line: duplicate-set-field
                    -- vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
                    --     opts = opts or {}
                    --     opts.border = opts.border or "double"
                    --     return orig_open_floating_preview(contents, syntax, opts, ...)
                    -- end

                    local function set_popup_border(winid)
                        if winid and winid >= 0 and vim.api.nvim_win_is_valid(winid) then
                            pcall(vim.api.nvim_win_set_config, winid, { border = "double" })
                        end
                    end

                    -- Case 1: item already has `info` — popup is created by C code before CompleteChanged
                    -- Lua callbacks fire; grab preview_winid after yielding to the event loop.
                    vim.api.nvim_create_autocmd("CompleteChanged", {
                        group = vim.api.nvim_create_augroup("CompletionPopupBorder", { clear = true }),
                        callback = function()
                            vim.schedule(function()
                                local info = vim.fn.complete_info({ "selected" })
                                set_popup_border(info.preview_winid)
                            end)
                        end,
                    })

                    -- Case 2: async LSP completionItem/resolve — popup is created via nvim__complete_set
                    -- after a network round-trip, long after CompleteChanged has already fired.
                    if vim.api.nvim__complete_set then
                        local orig = vim.api.nvim__complete_set
                        ---@diagnostic disable-next-line: duplicate-set-field
                        vim.api.nvim__complete_set = function(index, opts)
                            local windata = orig(index, opts)
                            set_popup_border(windata and windata.winid)
                            return windata
                        end
                    end
                end
                hack_border()
            end

            if client:supports_method("textDocument/formatting") then
                map({ "n", "x" }, "<F3>", "<Cmd>lua vim.lsp.buf.format({async = true})<CR>", "Format code")
            end

            -- prefer LSP folding (over treesitter) if the client supports it
            if client:supports_method("textDocument/foldingRange") then
                local win = vim.api.nvim_get_current_win()
                vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
            end

            -- utilize telescope to improve code navigation hotkeys
            map("n", "gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
            map("n", "gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
            map("i", "<C-S-Space>", vim.lsp.buf.signature_help, "Signature Help")
            map("n", "<F2>", vim.lsp.buf.rename, "Rename symbol")
            map("n", "<F4>", vim.lsp.buf.code_action, "Code action")
        end
    end,
})
