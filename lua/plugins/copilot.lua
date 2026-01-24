return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestions = { enable = false },
      panels = { enable = false },
      server_opts_overrides = {
        trace = "verbose",
        cmd = {
          vim.fn.expand("~/.local/share/nvim/mason/bin/copilot-language-server"),
          "--stdio",
        },
      },
      filetypes = { ["*"] = true },
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken",
    opts = {
      debug = false,
      language = "ja",
      auto_fold = true,

        -- stylua: ignore
      prompts = {
        Explain = { prompt = "/COPILOT_EXPLAIN コードを日本語で説明してください。" },
        Review = { prompt = "/COPILOT_REVIEW コードをレビューし、改善案を日本語で提示してください。" },
        Fix = { prompt = "/COPILOT_GENERATE このコードの問題を修正してください。修正内容は日本語で説明してください。" },
        Optimize = { prompt = "/COPILOT_GENERATE 選択したコードを最適化してパフォーマンスと可読性を向上させてください。" },
        Docs = { prompt = "/COPILOT_GENERATE 選択したコードにドキュメントコメントを追加してください。" },
        Tests = { prompt = "/COPILOT_GENERATE 選択したコードのユニットテストを生成してください。" },
      },

      window = {
        layout = "vertical",
        height = 0.5,
        border = "rounded",
        title = "  Copilot Chat ",
        zindex = 100, -- Ensure window stays on top
      },

      headers = {
        user = "   User ",
        assistant = "   Copilot ",
        tool = " 󱌣  Tool ",
      },
      separator = "━━",
    },
    keys = {
      {
        "<Leader>cc",
        function()
          require("CopilotChat").toggle()
        end,
        desc = "CopilotChat - Toggle",
      },
      {
        "<leader>cx",
        function()
          require("CopilotChat").reset()
          print("CopilotChat: Context reset")
        end,
        desc = "CopilotChat - Reset Chat",
      },
      {
        "<Leader>cq",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").visual })
          end
        end,
        mode = "v",
        desc = "CopilotChat - Quick Chat",
      },
      { "<Leader>cr", "<cmd>CopilotChatReview<cr>", mode = "v", desc = "CopilotChat - Review" },
      { "<Leader>cf", "<cmd>CopilotChatFix<cr>", mode = "v", desc = "CopilotChat - Fix" },
    },
  },
}
