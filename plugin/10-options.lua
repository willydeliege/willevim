vim.g.mapleader = " "
vim.opt.number = true -- Active les numéros de ligne absolus
vim.opt.relativenumber = true -- Active les numéros de ligne relatifs
vim.opt.winborder = "rounded" -- Options include 'single', 'double', 'rounded', 'none'
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.tabstop = 2 -- Insert 2 spaces for a tab
vim.opt.shiftwidth = 2 -- Number of spaces spaces for autoindenting
vim.opt.softtabstop = 2 -- Makes backspace delete 2 spaces like a tab
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end) -- Sync vim and system clipboard
vim.opt.signcolumn = "yes"
vim.opt.confirm = true -- raise dialog if you close unsaved buffer (prevent mistakes)
vim.opt.showmode = false -- don't show mode (given by lualine)
-- Enable persistent undo
local undo_dir = vim.fn.stdpath("data") .. "/undo"
if vim.fn.isdirectory(undo_dir) == 0 then
	vim.fn.mkdir(undo_dir, "p")
end

vim.opt.undodir = undo_dir
vim.opt.undofile = true
