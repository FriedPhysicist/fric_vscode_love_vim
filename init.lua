-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({ { "Failed to clone lazy.nvim:\n" .. out, "ErrorMsg" } }, true, {})
    return
  end
end
vim.opt.rtp:prepend(lazypath)

-- Basic options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.mouse = "a"
-- Yank to / paste from system clipboard (needs wl-clipboard or xclip/xsel)
vim.opt.clipboard = "unnamedplus"
-- Middle click: paste the PRIMARY selection like a normal terminal.
-- (nvim's built-in handler puts the unnamed register, which with
-- unnamedplus is the system clipboard -- not what middle click should do.)
vim.keymap.set({ "n", "v" }, "<MiddleMouse>", '"*P')
vim.keymap.set("i", "<MiddleMouse>", "<C-r><C-o>*")
-- Rider-style defaults
vim.g.mapleader = " "
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true
-- Smart / search: case-insensitive unless you type an uppercase letter
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
-- Esc clears search highlight
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Auto-reload files changed on disk (git pull, build scripts, etc.)
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  callback = function()
    -- never clobber unsaved local edits
    if vim.bo.modified then
      return
    end
    vim.cmd("checktime")
  end,
})
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  callback = function()
    vim.notify("Reloaded from disk: " .. vim.fn.expand("%"), vim.log.levels.INFO)
  end,
})

-- Lightline config must be set BEFORE plugins load (lightline caches it at init)
-- Status-bar diagnostics summary for the current buffer, e.g. "E2 W1"
vim.api.nvim_exec2([=[
function! LightlineDiagnostics() abort
  let parts = []
  for [sev, prefix] in [[1, 'E'], [2, 'W'], [3, 'I'], [4, 'H']]
    let n = luaeval('vim.diagnostic.count(0)[_A]', sev)
    if n > 0
      call add(parts, prefix . n)
    endif
  endfor
  return join(parts, ' ')
endfunction
]=], {})
vim.g.lightline = {
  colorscheme = "gruvbox",
  component_function = {
    diagnostics = "LightlineDiagnostics",
  },
  active = {
    left = { { "mode", "paste" }, { "readonly", "filename", "modified" } },
    right = {
      { "lineinfo" },
      { "percent" },
      { "fileformat", "fileencoding", "filetype", "diagnostics" },
    },
  },
}
-- keep the status bar in sync when LSP diagnostics arrive
vim.api.nvim_create_autocmd("DiagnosticChanged", {
  callback = function()
    vim.cmd("redrawstatus")
  end,
})

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- Colorscheme
    { "morhetz/gruvbox", lazy = false, priority = 1000 },
    -- Lightline statusline + gruvbox theme for it
    -- Theme plugin loads first (priority 100) so its palette exists when lightline inits
    { "shinchu/lightline-gruvbox.vim", lazy = false, priority = 100 },
    { "itchyny/lightline.vim", lazy = false },
    -- Start screen
    {
      "goolord/alpha-nvim",
      lazy = false,
      priority = 100,
      config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        -- ASCII art header
        dashboard.section.header.val = {
          "                                                     ",
          "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗  ",
          "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║  ",
          "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║  ",
          "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║  ",
          "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║  ",
          "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝   ╚═╝  ",
          "                                                     ",
        }
        dashboard.section.header.opts.hl = "Title"

        -- Menu buttons
        dashboard.section.buttons.val = {
          dashboard.button("f", "  Find file", "<cmd>FzfLua files<CR>"),
          dashboard.button("r", "  Recent files", "<cmd>FzfLua oldfiles<CR>"),
          dashboard.button("g", "  Find text", "<cmd>FzfLua live_grep<CR>"),
          dashboard.button("n", "  New file", "<cmd>enew<CR>"),
          dashboard.button("l", "  Lazy", "<cmd>Lazy<CR>"),
          dashboard.button("q", "  Quit", "<cmd>qa<CR>"),
        }
        dashboard.section.buttons.opts.hl = "String"

        -- Footer
        dashboard.section.footer.val = "gruvbox • neovim • lazy.nvim"
        dashboard.section.footer.opts.hl = "Comment"

        alpha.setup(dashboard.opts)
      end,
    },
    -- VSCode-style diff view
    {
      "esmuellert/codediff.nvim",
      cmd = "CodeDiff",
      keys = {
        { "<leader>cd", "<cmd>CodeDiff<CR>", desc = "CodeDiff (open diff view)" },
      },
      opts = {
        highlights = {
          -- dimmed tints of gruvbox green/red (defaults DiffAdd/DiffDelete are too bright)
          line_insert = "#454528", -- subtle green
          line_delete = "#522e2a", -- subtle red
        },
      },
    },
    -- Fuzzy finder
    {
      "ibhagwan/fzf-lua",
      -- lazy-load on the commands/mappings we use
      cmd = "FzfLua",
      keys = {
        { "<leader>ff", "<cmd>FzfLua files<CR>", desc = "Find files" },
        { "<leader>fg", "<cmd>FzfLua live_grep<CR>", desc = "Live grep" },
        { "<leader>fw", "<cmd>FzfLua grep_cword<CR>", desc = "Grep word under cursor" },
        { "<leader>fr", "<cmd>FzfLua resume<CR>", desc = "Resume last search" },
        { "<leader>fb", "<cmd>FzfLua buffers<CR>", desc = "Buffers" },
        { "<leader>fh", "<cmd>FzfLua help_tags<CR>", desc = "Help tags" },
      },
      opts = {},
    },
    -- Toggle comments on a line or visual selection (gc / gb)
    {
      "numToStr/Comment.nvim",
      lazy = false,
      keys = {
        { "gc", mode = { "n", "v" }, function() require("Comment.api").toggle.linewise.current() end, desc = "Toggle line comment" },
        { "gb", mode = { "n", "v" }, function() require("Comment.api").toggle.blockwise.current() end, desc = "Toggle block comment" },
      },
      config = function()
        require("Comment").setup()
      end,
    },
    -- Smart in-file search/jump (flash)
    {
      "folke/flash.nvim",
      event = "VeryLazy",
      opts = {
        search = {
          -- use vim regex mode so ignorecase/smartcase apply (exact mode is case-sensitive)
          mode = "search",
        },
      },
    },
    -- ==== Intellisense (C#, same engine as Rider) ====
    -- Server manager UI (roslyn-language-server itself is installed via dotnet tool)
    { "williamboman/mason.nvim", cmd = "Mason", build = ":MasonUpdate", opts = {} },
    {
      "neovim/nvim-lspconfig",
      config = function()
        -- Enable the C# server (config ships with lspconfig; binary from dotnet tool)
        vim.lsp.enable("roslyn_ls")

        -- inlay hints: disabled
        vim.lsp.inlay_hint.enable(false)

        vim.api.nvim_create_autocmd("LspAttach", {
          group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
          callback = function(args)
            local opts = { buffer = args.buf }
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
            vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
            vim.keymap.set("n", "<leader>f", function()
              vim.lsp.buf.format({ async = true })
            end, opts)
            vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)
          end,
        })

        -- no inline text, signs, or underlines: errors show only in the status bar
        vim.diagnostic.config({
          virtual_text = false,
          signs = false,
          underline = false,
          update_in_insert = false,
        })
      end,
    },
    -- Completion engine
    {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        { "L3MON4D3/LuaSnip", dependencies = { "rafamadriz/friendly-snippets" } },
      },
      config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        require("luasnip.loaders.from_vscode").lazy_load()
        cmp.setup({
          snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
          window = {
            completion = cmp.config.window.bordered({ max_height = 5 }), -- show 5 rows, scroll for more
            documentation = cmp.config.window.bordered(),
          },
          mapping = cmp.mapping.preset.insert({
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { "i", "s" }),
          }),
          sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "lsp_signature_help" }, -- Rider-style parameter hints
            { name = "luasnip" },
            { name = "path" },
          }, {
            { name = "buffer" },
          }),
        })
      end,
    },
    -- Syntax highlighting (core nvim via vim.treesitter.start)
    {
      "nvim-treesitter/nvim-treesitter",
      lazy = false,
      build = ":TSUpdate",
      config = function()
        -- enable treesitter highlighting for every filetype that has a parser
        vim.api.nvim_create_autocmd("FileType", {
          callback = function()
            pcall(vim.treesitter.start)
          end,
        })
        -- C# indentation: use battle-tested cindent instead of the
        -- experimental treesitter indentexpr (which returns 0 -> col 0)
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "cs",
          callback = function()
            vim.bo.indentexpr = ""
            vim.bo.autoindent = true
            vim.bo.cindent = true
          end,
        })
      end,
    },
    -- Problems panel (like Rider's "Problems" tool window)
    {
      "folke/trouble.nvim",
      cmd = { "Trouble" },
      keys = {
        { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics (Trouble)" },
        { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer Diagnostics (Trouble)" },
      },
      opts = {},
    },
  },
  install = { colorscheme = { "gruvbox" } },
  checker = {
    enabled = false,   -- no automatic update checks
  },
})

-- Colorscheme
vim.cmd.colorscheme("gruvbox")
