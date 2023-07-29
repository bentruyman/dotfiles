return {
	"neovim/nvim-lspconfig",
	opts = {
		servers = {
			dockerls = {},
			docker_compose_language_service = {},
			eslint = {
				settings = {
					-- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
					workingDirectory = { mode = "auto" },
				},
			},
			jsonls = {
				-- lazy-load schemastore when needed
				on_new_config = function(new_config)
					new_config.settings.json.schemas = new_config.settings.json.schemas or {}
					vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
				end,
				settings = {
					json = {
						validate = { enable = true },
					},
				},
			},
			tailwindcss = {
				filetypes_exclude = { "markdown" },
			},
			---@type lspconfig.options.tsserver
			tsserver = {
				keys = {
					{ "<leader>co", "<cmd>TypescriptOrganizeImports<CR>", desc = "Organize Imports" },
					{ "<leader>cR", "<cmd>TypescriptRenameFile<CR>", desc = "Rename File" },
				},
				settings = {
					typescript = {},
					javascript = {},
					completions = {
						completeFunctionCalls = true,
					},
				},
			},
			yamlls = {
				-- lazy-load schemastore when needed
				on_new_config = function(new_config)
					new_config.settings.yaml.schemas = new_config.settings.yaml.schemas or {}
					vim.list_extend(new_config.settings.yaml.schemas, require("schemastore").yaml.schemas())
				end,
				settings = {
					redhat = { telemetry = { enabled = false } },
					yaml = {
						keyOrdering = false,
						validate = { enable = true },
						schemaStore = {
							-- Must disable built-in schemaStore support to use
							-- schemas from SchemaStore.nvim plugin
							enable = false,
							-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
							url = "",
						},
					},
				},
			},
		},
		setup = {
			eslint = function()
				vim.api.nvim_create_autocmd("BufWritePre", {
					callback = function(event)
						if not require("lazyvim.plugins.lsp.format").enabled() then
							-- exit early if autoformat is not enabled
							return
						end

						local client = vim.lsp.get_active_clients({ bufnr = event.buf, name = "eslint" })[1]
						if client then
							local diag = vim.diagnostic.get(
								event.buf,
								{ namespace = vim.lsp.diagnostic.get_namespace(client.id) }
							)
							if #diag > 0 then
								vim.cmd("EslintFixAll")
							end
						end
					end,
				})
			end,
			tailwindcss = function(_, opts)
				local tw = require("lspconfig.server_configurations.tailwindcss")
				--- @param ft string
				opts.filetypes = vim.tbl_filter(function(ft)
					return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
				end, tw.default_config.filetypes)
			end,

			tsserver = function(_, opts)
				require("typescript").setup({ server = opts })
				return true
			end,
		},
	},
}
