
-- Git wrapper support providing interactive CLI commands inside Neovim.
-- Enables staging, committing, viewing diffs, and staging files quickly.
-- Works as an essential companion for external git workflow utilities.

return {
	"tpope/vim-fugitive",
	cmd = { "Git", "Gdiffsplit", "Gvdiffsplit", "Gwrite", "Gread" },
}
