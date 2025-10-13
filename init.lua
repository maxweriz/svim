-- ~/.config/nvim/init.lua (fresh)
-- Complete Neovim config with: lazy.nvim bootstrap, Neo-tree, Telescope, Treesitter,
-- LSP (pyright, rust-analyzer, starpls), cmp, lualine, gitsigns,
-- Sonoran Sun theme, Conform formatting, and terminal QoL.

------------------------------------------------------------
-- 0) Leader & Basic Options
------------------------------------------------------------
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

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
	-- UI niceties
	{ 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' } },
	{ 'lewis6991/gitsigns.nvim' },

	-- Themes
	{ 'catppuccin/nvim',           name = 'catppuccin' }, -- fallback

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
				enable_git_status = true,
				enable_diagnostics = true,
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
						['P'] = { 'toggle_preview', config = { use_float = true } },
					},
				},
				default_component_configs = {
					indent = { with_markers = true, indent_size = 2 },
					git_status = { symbols = { added = 'A', modified = 'M', deleted = 'D', renamed = 'R' } },
					diagnostics = { symbols = { hint = 'H', info = 'I', warn = 'W', error = 'E' } },
				},
			})
			local map_local = vim.keymap.set
			-- We'll override <leader>e later with a smarter function
			map_local('n', '<leader>e', '<cmd>Neotree toggle<CR>', { desc = 'Neo-tree: toggle' })
			map_local('n', '<leader>E', '<cmd>Neotree reveal<CR>', { desc = 'Neo-tree: reveal file' })
		end,
	},

	-- Telescope (fuzzy finding)
	{ 'nvim-telescope/telescope.nvim',            dependencies = { 'nvim-lua/plenary.nvim' } },

	-- Treesitter
	{ 'nvim-treesitter/nvim-treesitter',          build = ':TSUpdate' },

	-- LSP + Mason + Completion
	{ 'neovim/nvim-lspconfig' }, -- kept for compatibility; we don't call require('lspconfig') here
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
-- Theme (prefer Sonoran Sun, fallback to Catppuccin)
vim.g.sonoran_sun_variant = "hot" -- "hot", "dark", or "light"

vim.o.termguicolors = true
vim.cmd.colorscheme("sonoran-day")

vim.api.nvim_create_user_command('Sonoran', function(opts)
	vim.g.sonoran_sun_variant = opts.args
	vim.cmd.colorscheme('sonoran-day')
end, {
	nargs = 1,
	complete = function() return { 'hot', 'dark', 'light' } end,
})

-- Lualine
require('lualine').setup({ options = { theme = 'auto', globalstatus = true } })

-- Gitsigns
require('gitsigns').setup()

-- Telescope keymaps
local map = vim.keymap.set
map('n', '<leader>ff', '<cmd>Telescope find_files<CR>', { desc = 'Find files' })
map('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', { desc = 'Live grep' })
map('n', '<leader>fb', '<cmd>Telescope buffers<CR>', { desc = 'Buffers' })
map('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', { desc = 'Help' })

-- Treesitter
require('nvim-treesitter.configs').setup({
	ensure_installed = {
		'lua', 'vim', 'vimdoc', 'query',
		'bash', 'python', 'json', 'yaml', 'markdown', 'markdown_inline',
		'javascript', 'typescript', 'tsx', 'html', 'css', 'rust'
	},
	highlight = { enable = true },
	indent = { enable = true },
})

-- Which-key
require('which-key').setup({})

------------------------------------------------------------
-- 4) LSP (Neovim 0.11+ API) + Completion
------------------------------------------------------------
require('mason').setup()
require('mason-lspconfig').setup({
	ensure_installed = { 'pyright', 'lua_ls', 'rust_analyzer', 'starpls' },
})

-- Ensure non-LSP tools (formatters) via Mason Tool Installer
require('mason-tool-installer').setup({
	ensure_installed = {
		'buildifier', -- Bazel/Starlark formatter
	},
	auto_update = false,
	run_on_start = true,
})

-- nvim-cmp setup
local cmp = require('cmp')
local luasnip = require('luasnip')
cmp.setup({
	snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
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

-- Capabilities for LSP completion
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Shared on_attach
local function on_attach(_, bufnr)
	local bmap = function(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = 'LSP: ' .. desc })
	end
	bmap('n', 'gd', vim.lsp.buf.definition, 'Goto Definition')
	bmap('n', 'gr', require('telescope.builtin').lsp_references, 'References')
	bmap('n', 'gi', vim.lsp.buf.implementation, 'Goto Implementation')
	bmap('n', 'K', vim.lsp.buf.hover, 'Hover')
	bmap('n', '<leader>rn', vim.lsp.buf.rename, 'Rename')
	bmap('n', '<leader>ca', vim.lsp.buf.code_action, 'Code Action')
	bmap('n', '<leader>sd', require('telescope.builtin').diagnostics, 'Search Diagnostics')
end

-- Define server configs using the new API
vim.lsp.config['pyright'] = {
	capabilities = capabilities,
	on_attach = on_attach,
}

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

vim.lsp.config['rust_analyzer'] = {
	capabilities = capabilities,
	on_attach = on_attach,
}

-- Starlark via starpls (Bazel/Buck2)
vim.lsp.config['starpls'] = {
	capabilities = capabilities,
	on_attach = on_attach,
	cmd = { 'starpls' }, -- provided by Mason package "starpls"
	filetypes = { 'bzl', 'bazel' },
}

-- Enable the servers explicitly (avoids deprecated lspconfig.setup)
vim.lsp.enable({ 'pyright', 'lua_ls', 'rust_analyzer', 'starpls' })

------------------------------------------------------------
-- 4.1) Formatting via Conform
------------------------------------------------------------
-- Uses buildifier for Bazel/Starlark and rustfmt for Rust
require('conform').setup({
	formatters_by_ft = {
		bzl   = { 'buildifier' },
		bazel = { 'buildifier' },
		rust  = { 'rustfmt' },
	},
	format_on_save = {
		lsp_fallback = true,
		timeout_ms = 1000,
	},
})
-- NOTE: rustfmt is provided by Rust toolchain:
--   curl -fsSL https://sh.rustup.rs | sh
--   rustup component add rustfmt

------------------------------------------------------------
-- 5) Terminal QoL & Window Navigation
------------------------------------------------------------
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

-- <leader>h: 12-line horizontal terminal split using your login shell (loads your profile)
map('n', '<leader>h', function()
	local shell = (vim.env.SHELL or vim.o.shell) .. ' -l'
	vim.cmd('belowright 12split')
	vim.cmd('terminal ' .. shell)
	vim.cmd('startinsert')
end, { desc = 'Horizontal terminal (same profile)' })

-- Optional: vertical terminal on <leader>v
map('n', '<leader>v', function()
	local shell = (vim.env.SHELL or vim.o.shell) .. ' -l'
	vim.cmd('vsplit')
	vim.cmd('terminal ' .. shell)
	vim.cmd('startinsert')
end, { desc = 'Vertical terminal (same profile)' })

-- Refocus helpers
map('n', '<leader>p', '<C-w>p', { desc = 'Focus previous window' })
map('n', '<C-h>', '<C-w>h', { desc = 'Go to left split' })
map('n', '<C-j>', '<C-w>j', { desc = 'Go to lower split' })
map('n', '<C-k>', '<C-w>k', { desc = 'Go to upper split' })
map('n', '<C-l>', '<C-w>l', { desc = 'Go to right split' })

-- Fast split resizing with Shift+Arrows
map('n', '<S-Up>', ':resize +2<CR>', { silent = true, desc = 'Increase height' })
map('n', '<S-Down>', ':resize -2<CR>', { silent = true, desc = 'Decrease height' })
map('n', '<S-Left>', ':vertical resize -4<CR>', { silent = true, desc = 'Narrower' })
map('n', '<S-Right>', ':vertical resize +4<CR>', { silent = true, desc = 'Wider' })

------------------------------------------------------------
-- 6) Small Quality-of-life Commands
------------------------------------------------------------
-- Quit helper if last window is Neo-tree
vim.api.nvim_create_autocmd('BufEnter', {
	pattern = '*',
	callback = function()
		if vim.bo.filetype == 'neo-tree' and #vim.api.nvim_list_wins() == 1 then
			vim.cmd('quit')
		end
	end
})

------------------------------------------------------------
-- 7) Smarter <leader>e for Neo-tree
--    - If Neo-tree is focused: jump to the rightmost non–Neo-tree window
--    - If Neo-tree is open but not focused: focus it
--    - If Neo-tree is closed: open it
------------------------------------------------------------
local function smart_neotree()
	local current_win = vim.api.nvim_get_current_win()
	local current_buf = vim.api.nvim_win_get_buf(current_win)
	local current_ft  = vim.bo[current_buf].filetype

	-- Find the rightmost non-floating, non-neo-tree window
	local function rightmost_editor_win()
		local best_win, best_col = nil, -1
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			local cfg = vim.api.nvim_win_get_config(win)
			-- skip floats
			if not cfg.relative or cfg.relative == "" then
				local buf = vim.api.nvim_win_get_buf(win)
				local ft  = vim.bo[buf].filetype
				if ft ~= "neo-tree" then
					local pos = vim.api.nvim_win_get_position(win) -- {row, col}
					local col = pos and pos[2] or -1
					if col > best_col then
						best_col, best_win = col, win
					end
				end
			end
		end
		return best_win
	end

	-- If neo-tree is focused, hop to rightmost editor window
	if current_ft == 'neo-tree' then
		local target = rightmost_editor_win()
		if target then
			vim.api.nvim_set_current_win(target)
		end
		return
	end

	-- Otherwise: if there is a neo-tree window, focus it; if not, open it
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		local ft  = vim.bo[buf].filetype
		if ft == 'neo-tree' then
			if win ~= current_win then
				vim.api.nvim_set_current_win(win)
			end
			return
		end
	end

	-- No neo-tree open: open it
	vim.cmd('Neotree toggle')
end

-- Override the earlier mapping from the Neo-tree setup
vim.keymap.set('n', '<leader>e', smart_neotree, { desc = 'Neo-tree: focus/open; if focused → jump rightmost' })
