-- -------- --
-- commands --
-- -------- --

-- Copy the current file's path and current line number
vim.api.nvim_command('command CopyFilepath let @+ = expand("%:~") .. ":" .. line(".")')
