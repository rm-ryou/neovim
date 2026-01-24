return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- set an empty statusline till lualine loads
      vim.o.statusline = " "
    else
      -- hide the statusline on the starter page
      vim.o.laststatus = 0
    end
  end,
  opts = {
    options = {
      icons_enabled = true,
      theme = "auto",
      -- NOTE: Inactive sections are redundant with globalstatus enabled
      globalstatus = true, -- Use a single statusline at the bottom
      disabled_filetypes = {
        statusline = { "snacks_dashboard", "snacks_picker_list" },
        winbar = { "snacks_dashboard", "snacks_picker_list" },
      },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch" },
      lualine_c = { "filename" },
      lualine_x = { "encoding", "fileformat", "filetype" },
      lualine_y = {},
      lualine_z = {},
    },
    extensions = { "neo-tree", "lazy", "fzf" },
  },
}
