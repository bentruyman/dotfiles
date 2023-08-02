return {
	"zbirenbaum/copilot.lua",
	cond = function()
		-- only enable for projects on github.com
		if vim.fn.getcwd():match("^" .. os.getenv("HOME") .. "/Development/src/github.com") then
			return true
		end
		return false
	end,
}
