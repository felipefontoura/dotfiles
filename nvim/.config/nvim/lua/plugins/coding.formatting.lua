return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			formatters_by_ft = {
				-- JavaScript/TypeScript/WEB
				javascript = { "prettier", "eslint_d" },
				typescript = { "prettier", "eslint_d" },
				javascriptreact = { "prettier", "eslint_d" },
				typescriptreact = { "prettier", "eslint_d" },
				html = { "prettier" },
				css = { "prettier" },
				scss = { "prettier" },
				json = { "prettier" },
				markdown = { "prettier" },
				yaml = { "prettier" },

				-- Lua
				lua = { "stylua" },

				-- Python
				python = { "black", "isort" },

				-- Ruby
				ruby = { "rubocop" },
				eruby = { "erb_format" },
			},

			-- Set up format-on-save
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
		},
	},
}
