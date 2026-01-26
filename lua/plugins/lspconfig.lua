return {
  "neovim/nvim-lspconfig",
  dependencies = { "folke/snacks.nvim" },
  event = { "BufReadPre", "BufNewFile" },
  opts = function()
    local ret = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
      },
      inlay_hints = { enabled = true },
      codelens = { enabled = false },
      folds = { enabled = true },
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      servers = {
        -- configuration for all lsp servers
        ["*"] = {
          capabilities = {
            workspace = {
              fileOperations = {
                didRename = true,
                willRename = true,
              },
            },
          },
        },
        stylua = { enabled = false },
        lua_ls = {
          -- mason = false, -- set to false if you don't want this server to be installed with mason
          -- Use this to add any additional keymaps
          -- for specific lsp servers
          -- ---@type LazyKeysSpec[]
          -- keys = {},
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              codeLens = {
                enable = true,
              },
              completion = {
                callSnippet = "Replace",
              },
              doc = {
                privateName = { "^_" },
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
            },
          },
        },
        gopls = {},
      },
      setup = {},
    }
    return ret
  end,
  config = vim.schedule_wrap(function(_, opts)
    local snacks = require("snacks")

    -- stylua: ignore
    snacks.keymap.set("n", "<Leader>cl", function() snacks.picker.lsp_config() end, { desc = "Lsp Info"})
    snacks.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Goto Definition" })
    snacks.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "References" })
    snacks.keymap.set("n", "gI", vim.lsp.buf.implementation, { desc = "Goto Implementation" })
    snacks.keymap.set("n", "gy", vim.lsp.buf.type_definition, { desc = "Goto T[y]pe Definition" })
    snacks.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
    -- stylua: ignore
    snacks.keymap.set("n", "K", function() return vim.lsp.buf.hover() end, { desc = "Hover" })
    -- stylua: ignore
    snacks.keymap.set("n", "gK", function() return vim.lsp.buf.signature_help() end, { desc = "Signature Help" })
    -- stylua: ignore
    snacks.keymap.set("i", "<c-k>", function() return vim.lsp.buf.signature_help() end, { desc = "Signature Help" })
    -- stylua: ignore
    snacks.keymap.set("n", "<Leader>sj", function() snacks.picker.jumps() end, { desc = "Jump List" })

    -- inlay hints
    if opts.inlay_hints.enabled then
      snacks.util.lsp.on({ method = "textDocument/inlayHint" }, function(buffer)
        if
          vim.api.nvim_buf_is_valid(buffer)
          and vim.bo[buffer].buftype == ""
          and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
        then
          vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
        end
      end)
    end

    -- code lens
    if opts.codelens.enabled and vim.lsp.codelens then
      snacks.util.lsp.on({ method = "textDocument/codeLens" }, function(buffer)
        vim.lsp.codelens.refresh()
        vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
          buffer = buffer,
          callback = vim.lsp.codelens.refresh,
        })
      end)
    end

    -- diagnostics
    if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
      opts.diagnostics.virtual_text.prefix = function(diagnostic)
        local icons = { Error = " ", Warn = " ", Hint = " ", Info = " " }
        for d, icon in pairs(icons) do
          if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
            return icon
          end
        end
        return "●"
      end
    end
    vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

    if opts.servers["*"] then
      vim.lsp.config("*", opts.servers["*"])
    end

    -- 1. Check if mason-lspconfig is available without LazyVim.has
    local has_mason, mason_lspconfig = pcall(require, "mason-lspconfig")

    -- 2. Get all servers available through mason-lspconfig
    local mason_all = {}
    if has_mason then
      -- Get the mapping from lspconfig name to mason package name
      local mappings = require("mason-lspconfig.mappings").get_mason_map()
      mason_all = vim.tbl_keys(mappings.lspconfig_to_package)
    end

    local mason_exclude = {} ---@type string[]

    ---@return boolean? exclude automatic setup
    local function configure(server)
      if server == "*" then
        return false
      end

      local sopts = opts.servers[server]
      -- Ensure sopts is a table or determine if it's disabled
      sopts = sopts == true and {} or (not sopts) and { enabled = false } or sopts

      if sopts.enabled == false then
        table.insert(mason_exclude, server)
        return
      end

      -- Check if we should use Mason for this server
      local use_mason = sopts.mason ~= false and vim.tbl_contains(mason_all, server)

      -- Execute custom setup if defined in opts.setup
      local setup_func = opts.setup[server] or opts.setup["*"]
      if setup_func and setup_func(server, sopts) then
        table.insert(mason_exclude, server)
      else
        -- Standard Neovim 0.10+ way to configure and enable servers
        -- (Replacing LazyVim internal wrappers)
        vim.lsp.config(server, sopts)
        if not use_mason then
          vim.lsp.enable(server)
        end
      end
      return use_mason
    end

    -- 3. Filter servers that need to be installed via Mason
    local install = vim.tbl_filter(configure, vim.tbl_keys(opts.servers))

    -- 4. Final mason-lspconfig setup
    if has_mason then
      -- Instead of LazyVim.opts, we assume ensure_installed is passed via your local config or empty
      local ensure_installed = opts.ensure_installed or {}

      mason_lspconfig.setup({
        ensure_installed = vim.list_extend(install, ensure_installed),
        -- automatic_installation can be boolean or a table with exclude
        automatic_installation = { exclude = mason_exclude },
      })
    end
  end),
}
