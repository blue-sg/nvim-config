-- You can add your own plugins here or in other files in this directory!
-- See the kickstart.nvim README for more information

return {
	{
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup{
      size = 15,
      open_mapping = [[<c-\>]],  -- Ctrl-\ opens terminal
      hide_numbers = true,
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      direction = "float",        -- floating terminal
      close_on_exit = true,
      persist_size = true,
      shell = vim.o.shell,
    }

    local Terminal  = require('toggleterm.terminal').Terminal
    local float_term = Terminal:new({hidden = true, direction = "float"})

    -- Toggle floating terminal manually
    vim.keymap.set("n", "<F12>", function()
      float_term:toggle()
    end, {silent = true})

    -- Function to run current file in floating terminal
    function RunCurrentFile()
      local ft = vim.bo.filetype
      local file = vim.fn.expand("%:p")
      local cmd = ""

      if ft == "python" then
        cmd = "python3 " .. file
      elseif ft == "lua" then
        cmd = "lua " .. file
      elseif ft == "c" then
        cmd = "gcc " .. file .. " -o /tmp/a.out && /tmp/a.out"
      elseif ft == "cpp" then
        cmd = "g++ " .. file .. " -o /tmp/a.out && /tmp/a.out"
      elseif ft == "java" then
        cmd = "javac " .. file .. " && java " .. vim.fn.expand("%:t:r")
      elseif ft == "javascript" then
        cmd = "node " .. file
      else
        cmd = "echo 'No run command for this filetype'"
      end

      float_term:toggle()
      float_term:send(cmd)
    end

    -- Map key to run current file
    vim.keymap.set("n", "<F5>", RunCurrentFile, {silent = true})
  end
},
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
