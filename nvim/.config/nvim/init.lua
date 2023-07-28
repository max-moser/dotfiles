-- workaround for the "undefined global `vim`" warning all over the place
local vim = vim

-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- lazy.nvim complains if we change the leader after loading it
vim.g.mapleader = " "

-- load the plugins from "lua/plugins/*.lua"
require("lazy").setup("plugins")

-- load the settings and keymaps
require("config.settings")
require("config.keymaps")
require("config.autocommands")

-- for projects: if the only argument to vim is a directory, let's go there
local args = vim.fn.argv()
if #args == 1 and vim.fn.isdirectory(args[1]) == 1 then
    local project_dir = args[1]
    vim.cmd.cd(project_dir)

    -- store the session file in the XDG "data" path (usually `~/.local/share/...`)
    local session_data_dir = vim.fn.stdpath("data") .. "/sessions/"
    local cwd = vim.loop.cwd()
    vim.fn.mkdir(session_data_dir, "p")
    local session_file = session_data_dir .. cwd:gsub("/", "_")

    -- if we have a session file available for the project, restore the session
    if vim.fn.filereadable(session_file) == 1 then
        -- close the buffer that's open before restoring the session
        local cur_buf = vim.api.nvim_get_current_buf()
        vim.cmd.source(session_file)
        vim.cmd.bdelete({cur_buf, bang = true })

        -- sometimes it happens that there's another open buffer for the project dir
        local buffers = vim.api.nvim_list_bufs()
        if #buffers > 1 then
            for _, buf in pairs(buffers) do
                if vim.api.nvim_buf_get_name(buf) == cwd then
                    vim.cmd.bdelete({project_dir, bang = true})
                end
            end
        end
    end

    -- just before quitting vim, save the current session
    vim.api.nvim_create_autocmd("VimLeave", {
        group = vim.api.nvim_create_augroup("project_session", { clear = true }),
        callback = function()
            if vim.api.nvim_get_vvar("dying") == 0 then
                -- only save the session if vim is being quit normally
                vim.cmd.mksession({session_file, bang = true })
            end
        end,

    })
end
