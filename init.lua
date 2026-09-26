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
-- Wheel scroll amount per tick (default is ver:3,hor:6; prefix is "ver", not "vert")
vim.opt.mousescroll = "ver:1,hor:6"
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

-- Resize windows with , / . instead of Ctrl-w < / >
vim.keymap.set("n", ",", "<cmd>vertical resize -5<CR>")
vim.keymap.set("n", ".", "<cmd>vertical resize +5<CR>")

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
  colorscheme = "omni_dusk",
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
    { "harshrajsachan/omni.nvim", lazy = false, priority = 1000 },
    -- Lightline statusline + dusk palette
    {
      "itchyny/lightline.vim",
      lazy = false,
      config = function()
        local p = require("omnitheme.palettes.omni-dusk")
        vim.g["lightline#colorscheme#omni_dusk#palette"] = vim.fn["lightline#colorscheme#fill"]({
          normal = {
            left = { { p.bg, p.accent }, { p.fg, p.bg3 } },
            middle = { { p.dim, p.bg1 } },
            right = { { p.bg, p.accent }, { p.fg, p.bg3 } },
            error = { { p.bg, p.error } },
            warning = { { p.bg, p.warning } },
          },
          insert = { left = { { p.bg, p.cursor_insert }, { p.fg, p.bg3 } } },
          visual = { left = { { p.bg, p.cursor_visual }, { p.fg, p.bg3 } } },
          replace = { left = { { p.bg, p.cursor_replace }, { p.fg, p.bg3 } } },
          inactive = {
            left = { { p.dim, p.bg2 } },
            middle = { { p.dim, p.bg1 } },
            right = { { p.dim, p.bg2 } },
          },
          tabline = {
            left = { { p.fg, p.bg2 } },
            middle = { { p.dim, p.bg1 } },
            right = { { p.bg, p.accent } },
            tabsel = { { p.bg, p.accent } },
          },
        })
        vim.fn["lightline#init"]()
        vim.fn["lightline#colorscheme"]()
      end,
    },
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
        dashboard.section.footer.val = "omni dusk • neovim • lazy.nvim"
        dashboard.section.footer.opts.hl = "Comment"

        alpha.setup(dashboard.opts)
      end,
    },
    -- Unified Git diff + history sidebar
    {
      "esmuellert/codediff.nvim",
      cmd = "CodeDiff",
      keys = {
        { "<leader>cd", "<cmd>CodeDiff<CR>", desc = "Git diff view" },
        { "<leader>ch", "<cmd>CodeDiff history<CR>", desc = "Git repository history" },
      },
      opts = {
        diff = { layout = "inline" },
        highlights = {
          line_insert = "#354a2a",
          line_delete = "#562e2e",
          char_insert = "#4c6b35",
          char_delete = "#803e3e",
        },
        explorer = { position = "left" },
        history = { position = "left" },
      },
    },
    -- File explorer (sidebar tree)
    {
      "nvim-tree/nvim-tree.lua",
      cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
      keys = {
        { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "File explorer toggle" },
        { "<leader>E", "<cmd>NvimTreeFindFile<CR>", desc = "File explorer (find file)" },
      },
      opts = {
        sort_by = "case_sensitive",
        view = { width = 30 },
        renderer = { group_empty = true },
        filters = { dotfiles = false },
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
      opts = {
        files = {
          actions = {
            -- open selected file in a new tab on Enter (like ctrl-t)
            ["enter"] = function(selected, opts)
              require("fzf-lua").actions.file_tabedit(selected, opts)
            end,
          },
        },
      },
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
        -- Keep Roslyn off scratch and virtual diff/history buffers.
        local root_dir = vim.lsp.config.roslyn_ls.root_dir
        vim.lsp.config("roslyn_ls", {
          on_exit = function(code, signal)
            if code == 0 and signal == 0 then
              return
            end
            vim.defer_fn(function()
              if vim.v.exiting == vim.NIL and vim.lsp.is_enabled("roslyn_ls") then
                vim.lsp.enable("roslyn_ls")
              end
            end, 1000)
          end,
          root_dir = function(bufnr, on_dir)
            local name = vim.api.nvim_buf_get_name(bufnr)
            if vim.bo[bufnr].buftype ~= "" or name == "" or name:match("^%a[%w+.-]*://") then
              return
            end
            root_dir(bufnr, on_dir)
          end,
        })
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
            vim.keymap.set("n", "<leader>fu", vim.lsp.buf.references, opts)
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
            vim.keymap.set("n", "<leader>f", function()
              vim.lsp.buf.format({ async = true })
            end, opts)
            vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)
          end,
        })

        -- no inline text or signs; underline errors only
        vim.diagnostic.config({
          virtual_text = false,
          signs = false,
          underline = { severity = vim.diagnostic.severity.ERROR },
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
  install = { colorscheme = { "omni-dusk" } },
  checker = {
    enabled = false,   -- no automatic update checks
  },
})

-- Colorscheme
vim.cmd.colorscheme("omni-dusk")

-- yu: copy a "@<path> : <line>" reference ("start-end" for a range) to the clipboard
local function yank_reference(line1, line2)
  local path = vim.fn.expand("%:p")
  local root = vim.fn.systemlist("git rev-parse --show-toplevel")[1] or vim.uv.cwd()
  local rel = path
  if root and path:sub(1, #root) == root then
    rel = path:sub(#root + 2)
  end
  local range = line1 == line2 and tostring(line1) or (line1 .. "-" .. line2)
  local text = string.format("@%s : %s", rel, range)
  vim.fn.setreg("+", text)
  vim.notify("Yanked: " .. text)
end

vim.keymap.set("n", "yu", function()
  yank_reference(vim.fn.line("."), vim.fn.line("."))
end)
vim.keymap.set("v", "yu", function()
  -- during an active selection, '< / '> are not set yet; use v / . marks
  local a, b = vim.fn.line("v"), vim.fn.line(".")
  yank_reference(math.min(a, b), math.max(a, b))
end)
