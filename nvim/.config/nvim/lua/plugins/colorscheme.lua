-- define a list of color schemes to load
local default_colorscheme = vim.env.NVIM_COLORSCHEME or "kanagawa"

local colorschemes = {
    afterglow = { "danilo-augusto/vim-afterglow" },
    gruvbox = { "ellisonleao/gruvbox.nvim" },
    deus = { "ajmwagar/vim-deus" },
    nord = { "shaunsingh/nord.nvim" },
    nordic = { "AlexvZyl/nordic.nvim" },
    caret = { "projekt0n/caret.nvim" },
    catppuccin = {
        "catppuccin/nvim",
        default = "catppuccin-nvim",
    },
    kanagawa = {
        "rebelot/kanagawa.nvim",
        opts = { transparent = false },
    },
    jellybeans = {
        "WTFox/jellybeans.nvim",
        opts = { transparent = false },
        default = "jellybeans-muted",
    },
}

-- set the default entry to be non-lazy, high-priority, and set an init function
-- note: overriding the "config" function prevents the default "opts" mechanism
local default_entry = colorschemes[default_colorscheme]
default_entry.lazy = false
default_entry.priority = 1000
default_entry.init = function()
    vim.cmd.colorscheme(default_entry.default or default_colorscheme)
end
local plugins = { default_entry }

-- use only the package spec values for other color schemes, remove the keys
colorschemes[default_colorscheme] = nil
for _, config in pairs(colorschemes) do
    if config.lazy == nil then
        config.lazy = true
    end
    table.insert(plugins, 1, config)
end

return plugins
