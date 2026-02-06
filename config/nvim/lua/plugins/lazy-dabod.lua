return {
	"kristijanhusak/vim-dadbod-ui",
	cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
	dependencies = "vim-dadbod",
	keys = {
		{ "<leader>D", mode = { "n" }, false },
	},
	init = function()
		local data_path = vim.fn.stdpath("data")

		vim.g.db_ui_auto_execute_table_helpers = 1
		vim.g.db_ui_save_location = data_path .. "/dadbod_ui"
		vim.g.db_ui_show_database_icon = true
		vim.g.db_ui_tmp_query_location = data_path .. "/dadbod_ui/tmp"
		vim.g.db_ui_use_nerd_fonts = true
		vim.g.db_ui_use_nvim_notify = true

		vim.g.db_ui_execute_on_save = false
	end,
}
