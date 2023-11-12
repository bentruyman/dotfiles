return {
	"zbirenbaum/copilot.lua",
	cond = function()
		-- only enable for projects on github.com or Exercism
		local homePath = os.getenv("HOME")
		if
			vim.fn.getcwd():match("^" .. homePath .. "/Development/src/github.com")
			or vim.fn.getcwd():match("^" .. homePath .. "/Exercism")
		then
			return true
		end
		return false
	end,
}
