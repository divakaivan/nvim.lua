return {
	"Vigemus/iron.nvim",
	config = function()
		local iron = require("iron.core")
		local view = require("iron.view")
		local common = require("iron.fts.common")

		iron.setup({
			config = {
				-- Whether a repl should be discarded or not
				scratch_repl = true,
				-- Your repl definitions come here
				repl_definition = {
					sh = {
						-- Can be a table or a function that
						-- returns a table (see below)
						command = { "zsh" },
					},
					python = {
						command = { "ipython", "--no-autoindent" },
						-- format = common.bracketed_paste, -- add _python maybe?
						block_dividers = { "# ;;", "#;;" },
						format = function(lines, extras)
							result = require("iron.fts.common").bracketed_paste_python(lines, extras)
							filtered = vim.tbl_filter(function(line)
								return not string.match(line, "^%s*#")
							end, result)
							return filtered
						end,
					},
				},
				repl_filetype = function(bufnr, ft)
					return ft
				end,
				repl_open_cmd = view.split.vertical.rightbelow("%40"),
			},
			keymaps = {
				toggle_repl = "<space>rr",
				restart_repl = "<space>rR",
				send_motion = "<space>sc",
				visual_send = "<space>sc",
				send_file = "<space>sf",
				send_line = "<space>sl",
				send_paragraph = "<space>sp",
				send_until_cursor = "<space>su",
				send_code_block = "<space>sb",
				send_code_block_and_move = "<space>sn",
				cr = "<space>s<cr>",
				interrupt = "<space>s<space>",
				exit = "<space>sq",
				clear = "<space>cl",
			},
			-- If the highlight is on, you can change how it looks
			-- For the available options, check nvim_set_hl
			highlight = {
				italic = true,
			},
			ignore_blank_lines = true,
		})

		-- iron also has a list of commands, see :h iron-commands for all available commands
		-- vim.keymap.set("n", "<space>rf", "<cmd>IronFocus<cr>")
		-- vim.keymap.set("n", "<space>rh", "<cmd>IronHide<cr>")
	end,
}
