return {
	{ "marilari88/neotest-vitest" },
	{
		"nvim-neotest/neotest",
		dependencies = {
			"haydenmeade/neotest-jest",
			"marilari88/neotest-vitest",
		},
		keys = {
			{
				"<leader>tw",
				"<cmd>lua require('neotest').run.run({ jestCommand = 'jest --watch ' })<cr>",
				desc = "Run Watch",
			},
		},
		opts = function(_, opts)
			table.insert(
				opts.adapters,
				require("neotest-jest")({
					jestCommand = "npm test --",
					env = { CI = true },
					cwd = function()
						return vim.fn.getcwd()
					end,
				})
			)
			table.insert(opts.adapters, require("neotest-vitest"))
		end,
	},
}
