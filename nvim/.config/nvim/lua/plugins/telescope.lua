return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                -- the fzf-native extension supports ignoring spaces in the input
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                config = function(_, _)
                    require("telescope").load_extension("fzf")
                end,
            },
        },
        opts = {
            defaults = {
                mappings = {
                    i = {
                        ["<C-h>"] = "which_key",
                        ["<C-j>"] = "move_selection_next",
                        ["<C-k>"] = "move_selection_previous",
                        ["<Esc>"] = "close",

                        -- disable some keybindings s.t. the global ones apply
                        ["<C-a>"] = false,
                        ["<C-e>"] = false,
                        ["<M-b>"] = false,
                        ["<M-f>"] = false,
                    }
                }
            },
            pickers = {
                buffers = {
                    sort_mru = true,
                    mappings = {
                        i = {
                            ["<C-D>"] = "delete_buffer",
                        }
                    }
                }
            },
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                }
            },
        },
    },
}
