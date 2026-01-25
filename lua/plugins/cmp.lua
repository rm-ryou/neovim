return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    opts = function(_, opts)
      local cmp = require("cmp")
      -- Disable auto-selection to prevent accidental completion on Enter
      local auto_select = false

      -- Helper function to check if there are words before the cursor
      local has_words_before = function()
        if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
          return false
        end
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
      end

      -- Completion settings
      opts.auto_brackets = {}
      opts.completion = {
        -- Added 'noselect' to prevent automatic selection of the first item
        completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
      }
      opts.preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None

      -- Key mappings
      opts.mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),

        -- Tab: Select next item if menu is visible, jump if in snippet, or trigger completion
        ["<Tab>"] = vim.schedule_wrap(function(fallback)
          if cmp.visible() and has_words_before() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          elseif vim.snippet and vim.snippet.active({ direction = 1 }) then
            vim.snippet.jump(1)
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end),

        -- S-Tab: Select previous item or jump back in snippet
        ["<S-Tab>"] = vim.schedule_wrap(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
          elseif vim.snippet and vim.snippet.active({ direction = -1 }) then
            vim.snippet.jump(-1)
          else
            fallback()
          end
        end),

        ["<CR>"] = cmp.mapping.confirm({ select = false }),
        ["<C-e>"] = cmp.mapping.abort(),
      })

      opts.sources = cmp.config.sources({
        -- { name = "copilot" },
        { name = "lazydev", group_index = 0 },
        { name = "nvim_lsp" },
        { name = "path" },
      }, {
        { name = "buffer" },
      })
    end,
  },
  { "zbirenbaum/copilot-cmp", opts = {} },
}
