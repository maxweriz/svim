
-- ~/.config/nvim/init.lua
-- Batteries-included, portable Neovim config (drop-in replacement)
-- Highlights vs your original:
-- - <leader>e: Neo-tree focus/defocus (open or jump; if already focused → go back)
-- - <leader>E: Neo-tree reveal current file
-- - Safe Telescope requires inside LSP on_attach
-- - cmp_nvim_lsp loads on require (no InsertEnter race)
-- - Safer terminal spawn (termopen argv, no shell string concat)
-- - Diagnostic hover timer is closed on exit; width uses display width
-- - Removed surprise auto-quit when Neo-tree is last window (kept neo-tree's own close_if_last_window)

------------------------------------------------------------
-- 0) Leader & Basic Options
------------------------------------------------------------
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 500
vim.opt.signcolumn = 'yes'
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Lua module loader (Neovim 0.9+)
pcall(function() if vim.loader then vim.loader.enable() end end)

------------------------------------------------------------
-- 1) Bootstrap lazy.nvim
------------------------------------------------------------
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

------------------------------------------------------------
-- 2) Plugins (managed by lazy.nvim)
------------------------------------------------------------
require('lazy').setup({
  -- Icons (optional but improves UI)
  { 'nvim-tree/nvim-web-devicons', lazy = true },

  -- UI polish (lightweight)
  { 'stevearc/dressing.nvim', event = 'VeryLazy', opts = {} },
  { 'rcarriga/nvim-notify', lazy = true, opts = {} },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = { 'MunifTanjim/nui.nvim', 'rcarriga/nvim-notify' },
    opts = {},
  },
  { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', event = 'BufReadPost', opts = {} },

  -- Statusline
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({ options = { theme = 'auto', globalstatus = true } })
    end,
  },

  -- Git signs
  {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPre',
    config = function()
      require('gitsigns').setup()
    end,
  },

  -- File explorer: Neo-tree
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    cmd = { 'Neotree' },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    init = function()
      -- disable netrw (recommended by neo-tree)
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
    keys = {
      -- Focus/defocus: open or jump; if already focused → go back to last editor window
      {
        '<leader>e',
        function()
          local function is_float(win)
            local cfg = vim.api.nvim_win_get_config(win)
            return cfg and cfg.relative and cfg.relative ~= ''
          end
          local current_win = vim.api.nvim_get_current_win()
          local current_buf = vim.api.nvim_win_get_buf(current_win)
          local current_ft  = vim.bo[current_buf].filetype

          -- If already in neo-tree → defocus to previous non-floating, non-neo-tree window
          if current_ft == 'neo-tree' then
            -- try previous window first
            local prev = vim.fn.winnr('#')
            if prev > 0 then
              local pw = vim.fn.win_getid(prev)
              if pw ~= 0 and not is_float(pw) then
                vim.api.nvim_set_current_win(pw)
                return
              end
            end
            -- else pick rightmost non-floating, non-neo-tree
            local best_win, best_col = nil, -1
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              if not is_float(win) then
                local buf = vim.api.nvim_win_get_buf(win)
                if vim.bo[buf].filetype ~= 'neo-tree' then
                  local pos = vim.api.nvim_win_get_position(win)
                  local col = pos and pos[2] or -1
                  if col > best_col then best_col, best_win = col, win end
                end
              end
            end
            if best_win then vim.api.nvim_set_current_win(best_win) end
            return
          end

          -- If any neo-tree window exists, jump to it; else open it
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            if not is_float(win) then
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].filetype == 'neo-tree' then
                if win ~= current_win then vim.api.nvim_set_current_win(win) end
                return
              end
            end
          end
          vim.cmd('Neotree toggle')
        end,
        desc = 'Neo-tree: focus/defocus',
      },
      { '<leader>E', '<cmd>Neotree reveal<CR>', desc = 'Neo-tree: reveal file' },
    },
    config = function()
      require('neo-tree').setup({
        sources = { 'filesystem', 'buffers', 'git_status', 'document_symbols' },
        close_if_last_window = true,
        enable_git_status = true,
        enable_diagnostics = true,
        filesystem = {
          follow_current_file = { enabled = true },
          use_libuv_file_watcher = false, -- default safer for CPU/battery
          filtered_items = {
            visible = false,
            hide_dotfiles = false,
            hide_gitignored = true,
          },
        },
        window = {
          width = 34,
          mappings = {
            ['o'] = 'toggle_node',
            ['<space>'] = 'none',
            ['l'] = 'open',
            ['h'] = 'close_node',
            ['P'] = { 'toggle_preview', config = { use_float = true } },
          },
        },
        default_component_configs = {
          indent = { with_markers = true, indent_size = 2 },
          git_status = { symbols = { added = 'A', modified = 'M', deleted = 'D', renamed = 'R' } },
          diagnostics = { symbols = { hint = 'H', info = 'I', warn = 'W', error = 'E' } },
        },
      })
    end,
  },

  -- Telescope (fuzzy finding)
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', cond = vim.fn.executable('make') == 1 },
    },
    config = function()
      local telescope = require('telescope')
      telescope.setup({
        defaults = {
          file_ignore_patterns = { '%.git/', 'node_modules' },
          layout_strategy = 'flex',
          layout_config = { width = 0.95, height = 0.90 },
        },
      })
      pcall(telescope.load_extension, 'fzf')
      local map = vim.keymap.set
      map('n', '<leader>ff', '<cmd>Telescope find_files<CR>', { desc = 'Find files' })
      map('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', { desc = 'Live grep (ripgrep)' })
      map('n', '<leader>fb', '<cmd>Telescope buffers<CR>', { desc = 'Buffers' })
      map('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', { desc = 'Help' })
      map('n', '<leader>fr', '<cmd>Telescope resume<CR>', { desc = 'Resume last picker' })
      map('n', '<leader>fs', '<cmd>Telescope git_files<CR>', { desc = 'Git files' })
    end,
  },

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = {
          'lua', 'vim', 'vimdoc', 'query', 'regex',
          'bash', 'python', 'json', 'yaml', 'markdown', 'markdown_inline',
          'javascript', 'typescript', 'tsx', 'html', 'css', 'rust', 'toml',
        },
        highlight = { enable = true, additional_vim_regex_highlighting = false },
        indent = { enable = true, disable = { 'python', 'markdown' } },
        incremental_selection = { enable = true },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
            },
          },
        },
      })
    end,
  },
  { 'nvim-treesitter/nvim-treesitter-textobjects', event = 'BufReadPost' },

  -- Which-key (discoverability)
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      local wk = require('which-key')
      wk.setup({})
      wk.register({
        f = { name = '[F]ind (telescope)' },
        g = { name = '[G]it' },
        s = { name = '[S]earch/Diagnostics' },
        e = { name = '[E]xplorer (neo-tree)' },
        p = { name = '[P]revious window' },
        h = { name = 'Terminal: horizontal' },
        v = { name = 'Terminal: vertical' },
      }, { prefix = '<leader>' })
    end,
  },

  -- LSP plumbing
  { -- only load lspconfig on < 0.11 (0.11 uses vim.lsp.config)
    'neovim/nvim-lspconfig',
    enabled = function() return vim.fn.has('nvim-0.11') == 0 end,
  },
  {
    'williamboman/mason.nvim',
    build = ':MasonUpdate',
    cmd = { 'Mason', 'MasonInstall', 'MasonUninstall' },
    config = function() require('mason').setup() end,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'williamboman/mason.nvim' },
    config = function()
      require('mason-lspconfig').setup({
        ensure_installed = { 'pyright', 'lua_ls', 'rust_analyzer' },
        automatic_installation = true,
      })

      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local function on_attach(_, bufnr)
        local b = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = 'LSP: ' .. desc })
        end
        -- safe telescope wrappers
        local function tb(name)
          local ok, t = pcall(require, 'telescope.builtin')
          return (ok and t[name]) and t[name] or function() end
        end

        b('n', 'gd', vim.lsp.buf.definition, 'Goto Definition')
        b('n', 'gr', tb('lsp_references'), 'References')
        b('n', 'gi', vim.lsp.buf.implementation, 'Goto Implementation')
        b('n', 'K',  vim.lsp.buf.hover, 'Hover')
        b('n', '<leader>rn', vim.lsp.buf.rename, 'Rename')
        b('n', '<leader>ca', vim.lsp.buf.code_action, 'Code Action')
        b('n', '<leader>sd', tb('diagnostics'), 'Search Diagnostics')
        -- quick diagnostic navigation
        b('n', '[d', vim.diagnostic.goto_prev, 'Prev Diagnostic')
        b('n', ']d', vim.diagnostic.goto_next, 'Next Diagnostic')
      end

      if vim.fn.has('nvim-0.11') == 1 and vim.lsp and vim.lsp.config then
        -- ==== Neovim 0.11+ path (no lspconfig) ====
        vim.lsp.config['pyright'] = { capabilities = capabilities, on_attach = on_attach }
        vim.lsp.config['lua_ls'] = {
          capabilities = capabilities,
          on_attach = on_attach,
          settings = {
            Lua = {
              diagnostics = { globals = { 'vim' } },
              workspace = { checkThirdParty = false },
            },
          },
        }
        vim.lsp.config['rust_analyzer'] = { capabilities = capabilities, on_attach = on_attach }
        -- vim.lsp.config['starpls'] = { cmd = { 'starpls' }, filetypes = { 'bzl', 'starlark' }, capabilities = capabilities, on_attach = on_attach }
        vim.lsp.enable({ 'pyright', 'lua_ls', 'rust_analyzer' })
      else
        -- ==== Neovim <= 0.10 path (classic lspconfig) ====
        local lspconfig = require('lspconfig')
        lspconfig.pyright.setup({ capabilities = capabilities, on_attach = on_attach })
        lspconfig.lua_ls.setup({
          capabilities = capabilities,
          on_attach = on_attach,
          settings = {
            Lua = {
              diagnostics = { globals = { 'vim' } },
              workspace = { checkThirdParty = false },
            },
          },
        })
        lspconfig.rust_analyzer.setup({ capabilities = capabilities, on_attach = on_attach })
        -- lspconfig.starpls.setup({ cmd = { 'starpls' }, filetypes = { 'bzl', 'starlark' }, capabilities = capabilities, on_attach = on_attach })
      end
    end,
  },

  -- Autocompletion
  { 'hrsh7th/nvim-cmp', event = 'InsertEnter' },
  { 'hrsh7th/cmp-nvim-lsp', module = 'cmp_nvim_lsp' }, -- load-on-require (fixes race)
  { 'hrsh7th/cmp-buffer', event = 'InsertEnter' },
  { 'hrsh7th/cmp-path', event = 'InsertEnter' },
  { 'saadparwaiz1/cmp_luasnip', event = 'InsertEnter' },
  { 'L3MON4D3/LuaSnip', event = 'InsertEnter' },
  {
    'rafamadriz/friendly-snippets',
    event = 'InsertEnter',
    config = function() require('luasnip.loaders.from_vscode').lazy_load() end,
  },

  -- Formatting
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    config = function()
      require('conform').setup({
        formatters_by_ft = {
          lua = { 'stylua' },
          python = { 'ruff_fix', 'ruff_format' }, -- or {'black'}
          javascript = { 'prettierd' },
          typescript = { 'prettierd' },
          javascriptreact = { 'prettierd' },
          typescriptreact = { 'prettierd' },
          json = { 'prettierd' },
          yaml = { 'yamlfmt' }, -- switch to 'prettierd' if your team prefers
          markdown = { 'prettierd' },
          bzl = { 'buildifier' },
          rust = { 'rustfmt' },
        },
        format_on_save = {
          lsp_fallback = true,
          timeout_ms = 1000,
        },
      })
    end,
  },

  -- Linting
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      local lint = require('lint')
      lint.linters_by_ft = {
        python = { 'ruff' },
        javascript = { 'eslint_d' },
        typescript = { 'eslint_d' },
        javascriptreact = { 'eslint_d' },
        typescriptreact = { 'eslint_d' },
      }
      vim.api.nvim_create_autocmd('BufWritePost', {
        callback = function() lint.try_lint() end,
      })
    end,
  },

  -- Auto-install external tools
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    event = 'VeryLazy',
    dependencies = { 'williamboman/mason.nvim' },
    config = function()
      require('mason-tool-installer').setup({
        ensure_installed = {
          'stylua', 'prettierd', 'yamlfmt', 'ruff', 'buildifier',
          -- 'eslint_d', -- enable if you want it auto-managed
        },
        auto_update = false,
        run_on_start = true,
      })
    end,
  },

  -- Editing QoL
  {
    'numToStr/Comment.nvim',
    event = 'VeryLazy',
    config = function()
      local ok_ctx, ctx = pcall(require, 'ts_context_commentstring.integrations.comment_nvim')
      require('Comment').setup({
        mappings = { basic = true, extra = false },
        pre_hook = ok_ctx and ctx.create_pre_hook() or nil,
      })
    end
  },
  { 'JoosepAlviste/nvim-ts-context-commentstring', event = 'VeryLazy' },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require('nvim-autopairs').setup({})
      local ok_cmp, cmp = pcall(require, 'cmp')
      if ok_cmp then
        local cmp_autopairs = require('nvim-autopairs.completion.cmp')
        cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
      end
    end
  },
  { 'windwp/nvim-ts-autotag', event = 'InsertEnter', opts = {} },

  -- Diagnostics list / quick triage
  { 'folke/trouble.nvim', cmd = { 'Trouble' }, opts = {} },

  -- Quick file marks
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require('harpoon')
      harpoon:setup()
      local map = vim.keymap.set
      map('n', '<leader>ha', function() harpoon:list():add() end, { desc = 'Harpoon add' })
      map('n', '<leader>hh', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harpoon menu' })
    end,
  },

  -- Copilot (vimscript); avoid <Tab> conflict with cmp
  {
    'github/copilot.vim',
    event = 'InsertEnter',
    init = function()
      vim.g.copilot_no_tab_map = true
      vim.keymap.set('i', '<C-l>', 'copilot#Accept("<CR>")', { expr = true, silent = true, desc = 'Copilot accept' })
    end,
  },
}, {
  ui = { border = 'rounded' },
})

------------------------------------------------------------
-- 3) Colors / Theme (Sonoran kept, non-fatal if missing)
------------------------------------------------------------
vim.g.sonoran_sun_variant = 'hot' -- 'hot' | 'dark' | 'light'
pcall(vim.cmd.colorscheme, 'sonoran-day') -- ignore error if theme not present

vim.api.nvim_create_user_command('Sonoran', function(opts)
  vim.g.sonoran_sun_variant = opts.args
  pcall(vim.cmd.colorscheme, 'sonoran-day')
end, {
  nargs = 1,
  complete = function() return { 'hot', 'dark', 'light' } end,
})

------------------------------------------------------------
-- 4) nvim-cmp setup (with sane <CR>)
------------------------------------------------------------
local ok_cmp, cmp = pcall(require, 'cmp')
if ok_cmp then
  local luasnip = require('luasnip')
  cmp.setup({
    snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
    mapping = cmp.mapping.preset.insert({
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<CR>']      = cmp.mapping.confirm({ select = false }),
      ['<Tab>']     = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end,
      ['<S-Tab>']   = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end,
    }),
    sources = {
      { name = 'nvim_lsp' },
      { name = 'path' },
      { name = 'buffer' },
      { name = 'luasnip' },
    },
  })
end

------------------------------------------------------------
-- 5) Diagnostics UX (global)
------------------------------------------------------------
vim.diagnostic.config({
  virtual_text = { spacing = 2, prefix = '●' },
  float = { border = 'rounded' },
  severity_sort = true,
})

------------------------------------------------------------
-- 6) Diagnostic Hover Box (theme-colored, above cursor when possible)
------------------------------------------------------------
do
  local M = {}
  local state = { win = nil, buf = nil }
  local uv = vim.uv or vim.loop
  local timer = uv.new_timer()

  local severity_name = {
    [vim.diagnostic.severity.ERROR] = "Error",
    [vim.diagnostic.severity.WARN]  = "Warn",
    [vim.diagnostic.severity.INFO]  = "Info",
    [vim.diagnostic.severity.HINT]  = "Hint",
  }
  local severity_icon = {
    [vim.diagnostic.severity.ERROR] = "",
    [vim.diagnostic.severity.WARN]  = "",
    [vim.diagnostic.severity.INFO]  = "",
    [vim.diagnostic.severity.HINT]  = "",
  }

  local function close_box()
    if state.win and vim.api.nvim_win_is_valid(state.win) then
      pcall(vim.api.nvim_win_close, state.win, true)
    end
    if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
      pcall(vim.api.nvim_buf_delete, state.buf, { force = true })
    end
    state.win, state.buf = nil, nil
  end

  local function get_diag_under_cursor()
    local bufnr = 0
    local pos = vim.api.nvim_win_get_cursor(0) -- {line1, col0}
    local lnum = pos[1] - 1
    local col  = pos[2]
    local diags = vim.diagnostic.get(bufnr, { lnum = lnum })
    if #diags == 0 then return nil end
    local best = nil
    for _, d in ipairs(diags) do
      local c1 = (d.col or (d.range and d.range.start and d.range.start.character)) or 0
      local c2 = (d.end_col or (d.range and d.range["end"] and d.range["end"].character)) or c1
      if col >= c1 and col <= c2 then
        if not best or d.severity < best.severity then best = d end
      end
    end
    if best then return best end
    table.sort(diags, function(a, b) return a.severity < b.severity end)
    return diags[1]
  end

  local function format_lines(d)
    local sev = severity_name[d.severity] or "Info"
    local icon = severity_icon[d.severity] or ""
    local src = d.source and (" · " .. d.source) or ""
    local code = (d.code and (" · " .. tostring(d.code))) or ""
    local title = string.format("%s %s%s%s", icon, sev, src, code)

    local lines = {}
    for line in tostring(d.message):gmatch("[^\r\n]+") do
      table.insert(lines, line)
    end
    table.insert(lines, 1, title)
    return lines
  end

  local function open_box()
    close_box()
    local d = get_diag_under_cursor()
    if not d then return end

    local lines = format_lines(d)
    state.buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
    vim.bo[state.buf].bufhidden = "wipe"
    vim.bo[state.buf].modifiable = false
    vim.bo[state.buf].filetype = "diaghover"

    local sev = severity_name[d.severity] or "Info"
    local winhl = string.format("Normal:Diagnostic%s,FloatBorder:Diagnostic%s", sev, sev)

    local pos = vim.api.nvim_win_get_cursor(0)
    local row = pos[1] - 1
    local col = pos[2]
    local width = 0
    for _, l in ipairs(lines) do width = math.max(width, vim.fn.strdisplaywidth(l)) end
    width = math.min(math.max(width, 20), math.max(20, vim.api.nvim_win_get_width(0) - 4))
    local height = #lines

    local opts_above = {
      relative = 'win', win = 0, anchor = 'SW',
      row = row - 1, col = col, width = width, height = height,
      style = 'minimal', border = 'rounded', focusable = false, noautocmd = true,
    }
    local opts_below = {
      relative = 'win', win = 0, anchor = 'NW',
      row = row + 1, col = col, width = width, height = height,
      style = 'minimal', border = 'rounded', focusable = false, noautocmd = true,
    }

    local try_above = row - height >= 0
    local win = vim.api.nvim_open_win(state.buf, false, try_above and opts_above or opts_below)
    state.win = win

    if win and vim.api.nvim_win_is_valid(win) then
      vim.wo[win].winhl = winhl
      vim.wo[win].wrap = true
      vim.wo[win].linebreak = true
      vim.wo[win].breakindent = true
    end
  end

  function M.show() open_box() end
  function M.hide() close_box() end

  vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
    callback = function()
      local uv = vim.uv or vim.loop
      if timer and timer.stop then timer:stop() end
      timer:start(40, 0, function()
        vim.schedule(function()
          if get_diag_under_cursor() then open_box() else close_box() end
        end)
      end)
    end,
  })
  vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'InsertEnter', 'InsertLeave', 'BufLeave' }, {
    callback = function() close_box() end,
  })
  vim.api.nvim_create_autocmd('VimLeavePre', {
    callback = function() if timer and timer.close then pcall(timer.close, timer) end end,
  })

  vim.keymap.set('n', '<leader>se', function() M.show() end, { desc = 'Show diagnostic hover box' })
  vim.keymap.set('n', '<leader>sE', function() M.hide() end, { desc = 'Hide diagnostic hover box' })
end

------------------------------------------------------------
-- 7) Terminal QoL & Window Navigation
------------------------------------------------------------
local map = vim.keymap.set

-- Auto-enter insert mode in any terminal buffer; hide line numbers
vim.api.nvim_create_autocmd('TermOpen', {
  pattern = '*',
  callback = function()
    vim.cmd('startinsert')
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

-- Escape to leave terminal-mode quickly
map('t', '<Esc>', [[<C-\><C-n>]], { desc = 'Exit terminal mode' })

-- Terminal splits launching login shell explicitly (inherits your profile) - safe argv
local function spawn_login_shell_split(vertical)
  local shell = vim.env.SHELL or vim.o.shell
  local args
  if shell:find('bash') or shell:find('zsh') or shell:find('fish') then
    args = { shell, '-l' }
  else
    args = { shell }
  end
  if vertical then
    vim.cmd('vsplit')
  else
    vim.cmd('belowright 12split')
  end
  vim.fn.termopen(args)
  vim.cmd('startinsert')
end
map('n', '<leader>h', function() spawn_login_shell_split(false) end, { desc = 'Horizontal terminal (login shell)' })
map('n', '<leader>v', function() spawn_login_shell_split(true) end,  { desc = 'Vertical terminal (login shell)' })

-- Window nav parity in terminal mode
map('t', '<C-h>', [[<C-\><C-n><C-w>h]])
map('t', '<C-j>', [[<C-\><C-n><C-w>j]])
map('t', '<C-k>', [[<C-\><C-n><C-w>k]])
map('t', '<C-l>', [[<C-\><C-n><C-w>l]])

-- Refocus helpers
map('n', '<leader>p', '<C-w>p', { desc = 'Focus previous window' })
map('n', '<C-h>', '<C-w>h', { desc = 'Go to left split' })
map('n', '<C-j>', '<C-w>j', { desc = 'Go to lower split' })
map('n', '<C-k>', '<C-w>k', { desc = 'Go to upper split' })
map('n', '<C-l>', '<C-w>l', { desc = 'Go to right split' })

-- Fast split resizing with Shift+Arrows
map('n', '<S-Up>', ':resize +2<CR>', { silent = true, desc = 'Increase height' })
map('n', '<S-Down>', ':resize -2<CR>', { silent = true, desc = 'Decrease height' })
map('n', '<S-Left>', ':vertical resize -4<CR>', { silent = true, desc = 'Narrower ' })
map('n', '<S-Right>', ':vertical resize 4<CR>', { silent = true, desc = 'Wider' })

------------------------------------------------------------
-- 8) Small Quality-of-life Commands
------------------------------------------------------------
-- (Removed the auto-quit-if-last-window to avoid surprise exits)
