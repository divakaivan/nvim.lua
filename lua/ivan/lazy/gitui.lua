return {
	"aspeddro/gitui.nvim",
	config = function()
		require("gitui").setup()
        vim.keymap.set("n", "<leader>git", ":Gitui<CR>")
	end,
}

