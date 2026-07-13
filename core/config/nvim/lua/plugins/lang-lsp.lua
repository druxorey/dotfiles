
return {
	-- Mason package manager to install formatters, linters, and LSP servers.
	-- Installs binaries and dependencies automatically inside stdpath data.
	-- Integrates cleanly with neovim configuration setups and installer scripts.
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		build = ":MasonUpdate",
		opts = {
			ensure_installed = {
				-- Formatters
				"stylua",
				"shfmt",
				"black",
				"isort",
				"prettierd",
				"clang-format",
				"goimports",
				"latexindent",
				-- Linters
				"eslint_d",
				"golangci-lint",
				"ruff",
				"shellcheck",
				"yamllint",
				"stylelint",
			},
		},
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			mr.refresh(function()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end)
		end,
	},

	-- Mason bridge with nvim-lspconfig for smoother server setups.
	-- Maps mason package names directly to lspconfig configurations.
	-- Ensures that required server binaries are downloaded before loading.
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			ensure_installed = {
				"bashls",
				"pyright",
				"clangd",
				"gopls",
				"jsonls",
				"yamlls",
				"taplo",
				"html",
				"cssls",
				"lua_ls",
				"ts_ls",
				"texlab",
			},
		},
	},

	-- Core LSP Configuration library providing pre-configured setups for servers.
	-- Connects languages analyzer servers directly to the neovim core client.
	-- Enables autocompletes, definitions, diagnostics, formatting, and hovers.
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"b0o/SchemaStore.nvim",
		},
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local mason_lspconfig = require("mason-lspconfig")
			mason_lspconfig.setup({
				ensure_installed = {
					"bashls",
					"pyright",
					"clangd",
					"gopls",
					"jsonls",
					"yamlls",
					"taplo",
					"html",
					"cssls",
					"lua_ls",
					"ts_ls",
					"texlab",
				},
				handlers = {
					function(server_name)
						local opts = {
							capabilities = capabilities,
						}

						-- Custom settings for specific servers:
						if server_name == "bashls" then
							-- Custom settings matching user options for bashls
							opts.settings = {
								bashIde = {
									shellcheckArguments = "--exclude=SC2155,SC2086,SC2181,SC1090",
								},
							}
						elseif server_name == "jsonls" then
							-- SchemaStore schemas integration
							opts.settings = {
								json = {
									schemas = require("schemastore").json.schemas(),
									validate = { enable = true },
								},
							}
						elseif server_name == "yamlls" then
							-- SchemaStore schemas integration
							opts.settings = {
								yaml = {
									schemaStore = {
										enable = false,
										url = "",
									},
									schemas = require("schemastore").yaml.schemas(),
								},
							}
						elseif server_name == "lua_ls" then
							opts.settings = {
								Lua = {
									workspace = {
										checkThirdParty = false,
									},
									completion = {
										callSnippet = "Replace",
									},
								},
							}
						end

						lspconfig[server_name].setup(opts)
					end,
				},
			})

			-- Set default diagnostic icons
			local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end

			vim.diagnostic.config({
				underline = true,
				update_in_insert = false,
				virtual_text = {
					spacing = 4,
					source = "if_many",
					prefix = "●",
				},
				severity_sort = true,
			})
		end,
	},

	-- JSON and YAML schemas catalog providing schema validation templates.
	-- Automatically fetches schema guidelines for specific standard file structures.
	-- Integrates seamlessly with JSON/YAML language servers configurations.
	{
		"b0o/SchemaStore.nvim",
		lazy = true,
	},

	-- Clangd enhancements providing extra tools for C/C++ configurations.
	-- Displays inline parameter hints, AST trees, and type hierarchies.
	-- Extends default LSP capabilities with compiler-specific functionalities.
	{
		"p00f/clangd_extensions.nvim",
		lazy = true,
		config = function() end,
	},

	-- Python virtual environments selector helper using Telescope search.
	-- Automatically scans poetry, conda, pipenv, and global virtual directories.
	-- Updates active pyright configs dynamically upon changing environments.
	{
		"linux-cultist/venv-selector.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			"nvim-telescope/telescope.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		cmd = "VenvSelect",
		opts = {},
	},

	-- Neovim configuration development helper with dynamic typing.
	-- Configures Lua LSP settings automatically for nvim APIs and plugins.
	-- Enhances completion and diagnostics when writing local user configs.

	{
		"folke/lazydev.nvim",
		ft = "lua",
		cmd = "LazyDev",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				{ path = "snacks.nvim", words = { "Snacks" } },
				{ path = "lazy.nvim", words = { "LazyVim" } },
				{ path = "nvim-lspconfig", words = { "lspconfig.settings" } },
			},
		},
	},
}
