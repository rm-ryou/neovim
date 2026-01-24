local global = vim.g
local opt = vim.opt

-- Leader Key
global.mapleader = " "

-----------------------------------------------------------
-- Appearance
-----------------------------------------------------------
opt.syntax = "on" -- Enable syntax highlighting
opt.number = true -- Show line numbers
opt.cursorline = true -- Highlight the current line
opt.title = true -- Set the window title
opt.laststatus = 2 -- Always show the status line
opt.ruler = true -- Show the cursor potition
opt.showmatch = true -- Show matching parentheses
opt.list = true -- Show invisible characters
opt.listchars = { eol = "↴" }

-----------------------------------------------------------
-- Editing Behavior
-----------------------------------------------------------
-- Indentation
opt.expandtab = true -- Use spaces instead of tabs
opt.smarttab = true -- Be smart when using tabs
opt.tabstop = 2 -- Number of spaces that a <Tab> counts for
opt.softtabstop = 2 -- Number of spaces that a <Tab> counts for while editing
opt.shiftwidth = 2 -- Number of spaces to use for each step of indent
opt.autoindent = true -- Copy indent from current line when starting a new line
opt.smartindent = true -- Make indenting smarter
opt.cindent = true -- Enable specific indenting for C-style languages

-- Wrapping
opt.wrap = true -- Enable line wrap
opt.linebreak = true -- Wrap lines at convenient points
opt.textwidth = 500 -- Maximum width of text being inserted
opt.whichwrap:append("<,>,h,l") -- Allow keys to move cursor to the previous/next line

-- Others
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.hidden = true -- Hide buffer when it is abandoned
opt.history = 256 -- Number of command line history to keep
opt.cmdheight = 1 -- Height of the command bar
opt.ambiwidth = "single" -- Prevent E1512 by treating ambiguous-width chars as single width

-----------------------------------------------------------
-- Search and Completion
-----------------------------------------------------------
opt.ignorecase = true -- Ignore case in search patterns
opt.smartcase = true -- Override 'ignorecase' if search pattern contains upper case
opt.hlsearch = true -- Highlight all search matches
opt.incsearch = true -- Show search matches while typing
opt.wildmenu = true -- Enable enhanced command-line completion
opt.wildmode = "longest:full,full" -- Completion mode for wildmenu

-- Completion options
opt.complete:append("k")
opt.completeopt = "menu,menuone,noselect"
opt.pumheight = 10 -- Maximum number of items to show in the popup menu
opt.infercase = true -- Adjust case of match for completion

-----------------------------------------------------------
-- System and Files
-----------------------------------------------------------
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
opt.swapfile = false -- Recommended: Disable swap files
opt.foldmethod = "marker" -- Use markers for folding
