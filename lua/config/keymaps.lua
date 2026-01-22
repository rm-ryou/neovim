local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-----------------------------------------------------------
-- General Keymaps
-----------------------------------------------------------

-- Set prefix key to ","
keymap.set("n", ",", "<Plug>(customPrefix)", { silent = true })

-- Escape from insert mode with "jj"
keymap.set("i", "jj", "<ESC>", { silent = true })

-- Delete a single character without copying it into the register
keymap.set("n", "x", '"_x', opts)

-- Increment/Decrement numbers
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Select all text
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Clear search highlights
keymap.set("n", "<Leader>nh", ":nohlsearch<CR>", opts)

-----------------------------------------------------------
-- Tab Management
-----------------------------------------------------------

keymap.set("n", "te", ":tabnew<CR>", opts)   -- Open new tab
keymap.set("n", "tc", ":tabclose<CR>", opts) -- Close current tab
keymap.set("n", "tn", ":tabnext<CR>", opts)  -- Go to next tab
keymap.set("n", "tp", ":tabprev<CR>", opts)  -- Go to previous tab

-----------------------------------------------------------
-- Window Management
-----------------------------------------------------------

-- Split window
keymap.set("n", "<Plug>(customPrefix)w", "<C-W>s", opts) -- Split horizontally
keymap.set("n", "<Plug>(customPrefix)v", "<C-W>v", opts) -- Split vertically

-- Window control
keymap.set("n", "<Plug>(customPrefix)e", "<C-W>=", opts) -- Make windows equal size
keymap.set("n", "<Plug>(customPrefix)c", "<C-W>c", opts) -- Close current window

-- Use Ctrl + hjkl to move between windows
keymap.set("n", "<C-h>", "<C-w>h", opts) -- Move to the left window
keymap.set("n", "<C-j>", "<C-w>j", opts) -- Move to the window below
keymap.set("n", "<C-k>", "<C-w>k", opts) -- Move to the window above
keymap.set("n", "<C-l>", "<C-w>l", opts) -- Move to the right window
