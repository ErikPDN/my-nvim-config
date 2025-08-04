return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal left<CR>", { desc = "Open Neo-tree filesystem" })
		vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle Neo-tree" })
		vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal float<CR>", { desc = "Open Neo-tree buffers" })
		vim.keymap.set("n", "<leader>gs", ":Neotree git_status reveal float<CR>", { desc = "Open Neo-tree git status" })
		vim.keymap.set("n", "<leader>nf", ":Neotree focus<CR>", { desc = "Focus Neo-tree" })
		vim.keymap.set("n", "<leader>nr", ":Neotree reveal<CR>", { desc = "Reveal current file in Neo-tree" })
	end,
}
