-- You can add your own plugins here or in other files in this directory!
-- See the kickstart.nvim README for more information

return {
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvimtools/none-ls-extras.nvim",
      "jayp0521/mason-null-ls.nvim",
      "nvim-lua/plenary.nvim",
    },

    config = function()
      -- Mason integration for none-ls (formatters + linters)
      require("mason-null-ls").setup {
        ensure_installed = {
          "ruff",
          "prettier",
          "shfmt",
        },
        automatic_installation = true,
      }

      -- Load none-ls (formerly null-ls)
      local null_ls = require "null-ls"

      -- List of sources
      local sources = {
        -- Ruff linter
        require("none-ls.formatting.ruff").with {
          extra_args = { "--extend-select", "I" },
        },

        -- Ruff formatter
        require("none-ls.formatting.ruff_format"),

        -- Prettier
        null_ls.builtins.formatting.prettier.with {
          filetypes = { "json", "yaml", "markdown" },
        },

        -- Shell formatter
        null_ls.builtins.formatting.shfmt.with {
          args = { "-i", "4" },
        },
      }

      -- Auto-format on save
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

      null_ls.setup {
        sources = sources,
        on_attach = function(client, bufnr)
          if client.supports_method "textDocument/formatting" then
            vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format { async = false }
              end,
            })
          end
        end,
      }
    end,
  },
}
