return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,

                disable = function(lang, buf)
                    -- i prefer the built-in highlighting of 'git rebase' commands
                    if lang == "git_rebase" then
                        return true
                    end

                    -- if the file is larger than 5 MiB, treesitter starts becoming too slow for nice UX
                    -- with more than 30 MiB, it starts becoming painful
                    --
                    -- treesitter-based folds start causing some pain much earlier (~1.5 MiB)
                    local max_filesize = 5 * 1024 * 1024
                    local max_filesize_folds = 3 * 512 * 1024
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size then
                        if stats.size > max_filesize then
                            -- disable if the file is too large
                            return true
                        elseif vim.opt.foldexpr:get() == "0" and stats.size < max_filesize_folds then
                            -- if the file is small enough, enable treesitter-based folds
                            vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
                        end
                    end

                    return false
                end,
            },
            incremental_selection = {
                enable = true,
            },
            indent = {
                enable = true,
            },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },
}
