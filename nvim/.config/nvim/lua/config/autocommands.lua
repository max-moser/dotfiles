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
vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP setup",
    callback = function(event)
        local opts = { buffer = event.buf }
        local map = function(mode, keys, func, desc)
            vim.keymap.set(mode, keys, func, { buffer = opts.buffer, desc = "LSP: " .. desc })
        end

        -- utilize telescope to improve code navigation hotkeys
        map("n", "gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
        map("n", "gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
        map("i", "<C-S-Space>", "<Cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature Help")
        map("n", "<F2>", "<Cmd>lua vim.lsp.buf.rename()<CR>", "Rename symbol")
        map({ "n", "x" }, "<F3>", "<Cmd>lua vim.lsp.buf.format({async = true})<CR>", "Format code")
        map("n", "<F4>", "<Cmd>lua vim.lsp.buf.code_action()<CR>", "Code action")
    end
})
