-- define a list of color schemes to load
local default_colorscheme = "catppuccin"
local colorschemes = {
    afterglow="danilo-augusto/vim-afterglow",
    gruvbox="ellisonleao/gruvbox.nvim",
    deus="ajmwagar/vim-deus",
    nord="shaunsingh/nord.nvim",
    catppuccin="catppuccin/nvim",
    caret="projekt0n/caret.nvim",
}

local plugins = {
    {
        -- the main color scheme needs to be loaded first
        colorschemes[default_colorscheme],
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme(default_colorscheme)
        end
    },

}

-- add the above defined color schemes to the list of plugins
colorschemes[default_colorscheme] = nil
for _, repo in pairs(colorschemes) do
    local entry = {
        repo,
        lazy = true,
    }
    table.insert(plugins, 1, entry)
end

return plugins
