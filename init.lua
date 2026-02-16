-- ~/.config/nvim/init.lua
-- Complete Neovim config with: lazy.nvim bootstrap, Neo-tree, Telescope, Treesitter,
-- LSP, cmp, lualine, gitsigns, Sonoran Sun theme, Conform formatting, and terminal QoL.

------------------------------------------------------------
-- 0) Leader & Basic Options
------------------------------------------------------------
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Define map helper globally for the whole file
local map = vim.keymap.set

-- Use your login shell so terminals inherit your profile (zsh/bash/etc.)
vim.opt.shell = vim.env.SHELL or vim.o.shell

-- Sensible defaults
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 400
vim.opt.signcolumn = 'yes'
vim.opt.splitbelow = true
vim.opt.splitright = true

------------------------------------------------------------
-- 1) Bootstrap lazy.nvim
------------------------------------------------------------
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
-- Note: vim.loop is deprecated in 0.10+, replaced by vim.uv
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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
	-- UI niceties
	{ 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' } },
	{ 'lewis6991/gitsigns.nvim' },

	-- Themes
	{ 'catppuccin/nvim',           name = 'catppuccin' },

	-- File explorer: Neo-tree
	{
		'nvim-neo-tree/neo-tree.nvim',
		branch = 'v3.x',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-tree/nvim-web-devicons',
			'MunifTanjim/nui.nvim',
		},
		init = function()
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1
		end,
		config = function()
			require('neo-tree').setup({
				sources = { 'filesystem', 'buffers', 'git_status', 'document_symbols' },
				close_if_last_window = true,
				filesystem = {
					follow_current_file = { enabled = true },
					use_libuv_file_watcher = true,
					filtered_items = {
						visible = false,
						hide_dotfiles = false,
						hide_gitignored = true,
					},
				},
				window = {
					width = 34,
					mappings = {
						['<space>'] = 'toggle_node',
						['l'] = 'open',
						['h'] = 'close_node',
					},
				},
			})
		end,
	},

	-- Telescope (fuzzy finding)
	{ 'nvim-telescope/telescope.nvim',            dependencies = { 'nvim-lua/plenary.nvim' } },

	-- Treesitter
	{ 'nvim-treesitter/nvim-treesitter',          build = ':TSUpdate' },

	-- LSP + Mason + Completion
	{ 'neovim/nvim-lspconfig' },
	{ 'williamboman/mason.nvim' },
	{ 'williamboman/mason-lspconfig.nvim' },

	-- Autocompletion
	{ 'hrsh7th/nvim-cmp' },
	{ 'hrsh7th/cmp-nvim-lsp' },
	{ 'hrsh7th/cmp-buffer' },
	{ 'hrsh7th/cmp-path' },
	{ 'L3MON4D3/LuaSnip' },
	{ 'saadparwaiz1/cmp_luasnip' },

	-- Which-key (discoverability)
	{ 'folke/which-key.nvim' },

	-- Formatting
	{ 'stevearc/conform.nvim' },

	-- Auto-install external tools (formatters/linters)
	{ 'WhoIsSethDaniel/mason-tool-installer.nvim' },

	-- Copilot
	{ 'github/copilot.vim' }
}, {
	ui = { border = 'rounded' },
})

------------------------------------------------------------
-- 3) Plugin Config
------------------------------------------------------------
-- Theme
vim.g.sonoran_sun_variant = "hot"
-- If sonoran-day is not installed, this will error.
-- Ensure you have the plugin or fallback to catppuccin.
pcall(vim.cmd.colorscheme, "sonoran-day")

-- Lualine
require('lualine').setup({ options = { theme = 'auto', globalstatus = true } })

-- Gitsigns
require('gitsigns').setup()

-- Telescope keymaps
map('n', '<leader>ff', '<cmd>Telescope find_files<CR>', { desc = 'Find files' })
map('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', { desc = 'Live grep' })
map('n', '<leader>fb', '<cmd>Telescope buffers<CR>', { desc = 'Buffers' })
map('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', { desc = 'Help' })

-- Treesitter
require('nvim-treesitter.configs').setup({
	ensure_installed = {
		'lua', 'vim', 'vimdoc', 'query', 'bash', 'python', 'json',
		'yaml', 'markdown', 'markdown_inline', 'javascript', 'typescript',
		'tsx', 'html', 'css', 'rust'
	},
	highlight = { enable = true },
	indent = { enable = true },
})

-- Which-key
require('which-key').setup({})

------------------------------------------------------------
-- 4) LSP Configuration & UI Overlap Fix
------------------------------------------------------------

-- FIX: Configure Diagnostics to not overlap text automatically
vim.diagnostic.config({
	-- Show "ghost text" at the end of the line (non-intrusive)
	virtual_text = {
		prefix = '●', -- Could use '■', '▎', 'x'
	},
	-- Don't update while typing (reduces noise)
	update_in_insert = false,
	-- Enable underline
	underline = true,
	-- FIX: Configure the floating window
	float = {
		border = 'rounded',
		source = 'always',
		header = '',
		prefix = '',
	},
})

-- We do NOT add a CursorHold autocommand here.
-- This prevents the popup from blocking your view automatically.
-- Instead, use <leader>d (configured below) to see the full message.

require('mason').setup()
require('mason-lspconfig').setup({
	ensure_installed = { 'pyright', 'lua_ls', 'rust_analyzer', 'starpls' },
})

require('mason-tool-installer').setup({
	ensure_installed = { 'buildifier' },
	auto_update = false,
	run_on_start = true,
})

-- nvim-cmp setup
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
	snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		['<C-Space>'] = cmp.mapping.complete(),
		['<CR>']      = cmp.mapping.confirm({ select = true }),
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
	sources = { { name = 'nvim_lsp' }, { name = 'path' }, { name = 'buffer' }, { name = 'luasnip' } },
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local function on_attach(_, bufnr)
	local bmap = function(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = 'LSP: ' .. desc })
	end
	bmap('n', 'gd', vim.lsp.buf.definition, 'Goto Definition')
	bmap('n', 'gr', require('telescope.builtin').lsp_references, 'References')
	bmap('n', 'K', vim.lsp.buf.hover, 'Hover Documentation')
	bmap('n', '<leader>rn', vim.lsp.buf.rename, 'Rename')
	bmap('n', '<leader>ca', vim.lsp.buf.code_action, 'Code Action')
	-- FIX: Open the diagnostic float manually
	bmap('n', '<leader>d', vim.diagnostic.open_float, 'Show Line Diagnostics')
	bmap('n', '<leader>sd', require('telescope.builtin').diagnostics, 'Search Diagnostics')
end

vim.lsp.config['pyright'] = { capabilities = capabilities, on_attach = on_attach }
vim.lsp.config['rust_analyzer'] = { capabilities = capabilities, on_attach = on_attach }
vim.lsp.config['starpls'] = { capabilities = capabilities, on_attach = on_attach, cmd = { 'starpls' }, filetypes = { 'bzl', 'bazel' } }
vim.lsp.config['lua_ls'] = {
	capabilities = capabilities,
	on_attach = on_attach,
	settings = { Lua = { diagnostics = { globals = { 'vim' } }, workspace = { checkThirdParty = false } } },
}

vim.lsp.enable({ 'pyright', 'lua_ls', 'rust_analyzer', 'starpls' })

------------------------------------------------------------
-- 4.1) Formatting via Conform
------------------------------------------------------------
require('conform').setup({
	formatters_by_ft = {
		bzl   = { 'buildifier' },
		bazel = { 'buildifier' },
		rust  = { 'rustfmt' },
	},
	format_on_save = { lsp_fallback = true, timeout_ms = 1000 },
})

------------------------------------------------------------
-- 5) Terminal QoL (FIXED)
------------------------------------------------------------
-- Auto-enter insert mode
vim.api.nvim_create_autocmd('TermOpen', {
	pattern = '*',
	callback = function()
		vim.cmd('startinsert')
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
	end,
})

map('t', '<Esc>', [[<C-\><C-n>]], { desc = 'Exit terminal mode' })

-- FIX: Robust Terminal Opening using termopen + enew
map('n', '<leader>h', function()
	local shell_path = vim.env.SHELL or vim.o.shell
	vim.cmd('belowright 12split')
	vim.cmd('enew') -- Force new buffer to avoid Neo-tree conflicts
	vim.fn.termopen({ shell_path, "-l" })
end, { desc = 'Horizontal terminal' })

map('n', '<leader>v', function()
	local shell_path = vim.env.SHELL or vim.o.shell
	vim.cmd('vsplit')
	vim.cmd('enew')
	vim.fn.termopen({ shell_path, "-l" })
end, { desc = 'Vertical terminal' })

-- Navigation
map('n', '<leader>p', '<C-w>p', { desc = 'Focus previous window' })
map('n', '<C-h>', '<C-w>h', { desc = 'Left split' })
map('n', '<C-j>', '<C-w>j', { desc = 'Lower split' })
map('n', '<C-k>', '<C-w>k', { desc = 'Upper split' })
map('n', '<C-l>', '<C-w>l', { desc = 'Right split' })

-- Resize
map('n', '<S-Up>', ':resize +2<CR>', { silent = true })
map('n', '<S-Down>', ':resize -2<CR>', { silent = true })
map('n', '<S-Left>', ':vertical resize -4<CR>', { silent = true })
map('n', '<S-Right>', ':vertical resize +4<CR>', { silent = true })

------------------------------------------------------------
-- 6) Helper Logic
------------------------------------------------------------
-- Quit if last window is Neo-tree
vim.api.nvim_create_autocmd('BufEnter', {
	pattern = '*',
	callback = function()
		if vim.bo.filetype == 'neo-tree' and #vim.api.nvim_list_wins() == 1 then
			vim.cmd('quit')
		end
	end
})

-- Smarter Neo-tree toggle
local function smart_neotree()
	local current_win = vim.api.nvim_get_current_win()
	local current_buf = vim.api.nvim_win_get_buf(current_win)
	local current_ft  = vim.bo[current_buf].filetype

	local function rightmost_editor_win()
		local best_win, best_col = nil, -1
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			local cfg = vim.api.nvim_win_get_config(win)
			if (not cfg.relative or cfg.relative == "") then
				local buf = vim.api.nvim_win_get_buf(win)
				local ft  = vim.bo[buf].filetype
				if ft ~= "neo-tree" then
					local pos = vim.api.nvim_win_get_position(win)
					local col = pos and pos[2] or -1
					if col > best_col then best_col, best_win = col, win end
				end
			end
		end
		return best_win
	end

	if current_ft == 'neo-tree' then
		local target = rightmost_editor_win()
		if target then vim.api.nvim_set_current_win(target) end
		return
	end

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].filetype == 'neo-tree' then
			vim.api.nvim_set_current_win(win)
			return
		end
	end

	vim.cmd('Neotree toggle')
end

map('n', '<leader>e', smart_neotree, { desc = 'Neo-tree smart toggle' })
