require("ivan.set")
require("ivan.remap")
require("ivan.lazy_init")

local augroup = vim.api.nvim_create_augroup
local IvanGroup = augroup("Ivan", {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", {})

function R(name)
	require("plenary.reload").reload_module(name)
end

vim.filetype.add({
	extension = {
		templ = "templ",
	},
})

autocmd("TextYankPost", {
	group = yank_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
})

autocmd({ "BufWritePre" }, {
	group = IvanGroup,
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

autocmd("BufEnter", {
	group = IvanGroup,
	callback = function()
		if vim.bo.filetype == "zig" then
			vim.cmd.colorscheme("tokyonight-night")
		else
			vim.cmd.colorscheme("rose-pine-moon")
		end
	end,
})

autocmd("LspAttach", {
	group = IvanGroup,
	callback = function(e)
		local opts = { buffer = e.buf }
		vim.keymap.set("n", "gd", function()
			vim.lsp.buf.definition()
		end, opts)
		vim.keymap.set("n", "K", function()
			vim.lsp.buf.hover()
		end, opts)
		vim.keymap.set("n", "<leader>vws", function()
			vim.lsp.buf.workspace_symbol()
		end, opts)
		vim.keymap.set("n", "<leader>vd", function()
			vim.diagnostic.open_float()
		end, opts)
		vim.keymap.set("n", "<leader>vca", function()
			vim.lsp.buf.code_action()
		end, opts)
		vim.keymap.set("n", "<leader>vrr", function()
			vim.lsp.buf.references()
		end, opts)
		vim.keymap.set("n", "<leader>vrn", function()
			vim.lsp.buf.rename()
		end, opts)
		vim.keymap.set("i", "<C-h>", function()
			vim.lsp.buf.signature_help()
		end, opts)
		vim.keymap.set("n", "[d", function()
			vim.diagnostic.goto_next()
		end, opts)
		vim.keymap.set("n", "]d", function()
			vim.diagnostic.goto_prev()
		end, opts)
	end,
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

local view_dir = vim.fn.expand("~/.config/nvim/views")
if vim.fn.isdirectory(view_dir) == 0 then
	vim.fn.mkdir(view_dir, "p")
end

vim.opt.viewdir = view_dir

local remember_folds = vim.api.nvim_create_augroup("remember_folds", { clear = true })

vim.api.nvim_create_autocmd("BufWinLeave", {
	group = remember_folds,
	pattern = { "*.py", "*.yaml", "*.yml" },
	command = "silent! mkview",
})

vim.api.nvim_create_autocmd("BufWinEnter", {
	group = remember_folds,
	pattern = { "*.py", "*.yaml", "*.yml" },
	command = "silent! loadview",
})

vim.api.nvim_create_user_command("FoldDocstrings", function()
	local current_line = vim.fn.line(".")
	local current_col = vim.fn.col(".")
	vim.cmd("normal! gg")
	while vim.fn.search("\"\"\"\\|'''", "W") ~= 0 do
		local start_line = vim.fn.line(".")
		if vim.fn.search("\"\"\"\\|'''", "W") ~= 0 then
			local end_line = vim.fn.line(".")
			vim.cmd(start_line .. "," .. end_line .. "fold")
		end
	end
	vim.fn.cursor(current_line, current_col)
end, {})

vim.keymap.set("n", "zp", ":FoldDocstrings<CR>", {
	desc = "Fold current docstring",
})
