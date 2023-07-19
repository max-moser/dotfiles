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
    vim.cmd.cd(args[1])
end
