return {
	"nvim-neo-tree/neo-tree.nvim",
	config = function()
		require("neo-tree").setup({
			window = {
				width = 30,
			},
		})
	end,
}
