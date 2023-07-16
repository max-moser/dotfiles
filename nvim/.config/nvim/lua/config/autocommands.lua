-- ------------ --
-- autocommands --
-- ------------ --

local api = vim.api

-- jump to the last position when reopening a file
api.nvim_create_autocmd("BufReadPost", {
    group = api.nvim_create_augroup("last_location", { clear = true }),
    callback = function()
        local exclude = { "gitcommit" }
        local buffer = api.nvim_get_current_buf()
        if vim.tbl_contains(exclude, vim.bo[buffer].filetype) then
            return
        end

        local mark = api.nvim_buf_get_mark(buffer, '"')
        local line_count = api.nvim_buf_line_count(buffer)
        if mark[1] > 0 and mark[1] < line_count then
            pcall(api.nvim_win_set_cursor, 0, mark)
        end
    end
})
