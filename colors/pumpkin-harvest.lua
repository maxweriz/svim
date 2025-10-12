-- File: colors/pumpkin-harvest.lua
-- A mid‑tone, autumnal pumpkin theme for Neovim
-- License: MIT
--
-- Install: save to ~/.config/nvim/colors/pumpkin-harvest.lua
-- Enable with: :colorscheme pumpkin-harvest

local config = {
	transparent = false,
	dim_inactive = false,
	italics = true,
}

-- Warm gourds, candlelight ambers, vine greens on a mid‑tone brown-black
local p = {
	bg         = "#17130f", -- mid-dark umber
	bg_dim     = "#1b1712",
	bg_alt     = "#201b14",
	ui         = "#262016",
	gutter     = "#2f281b",
	cursorline = "#221c14",

	fg         = "#f2ebe3", -- parchment
	fg_dim     = "#d8cec4",
	comment    = "#8e7f71", -- toasted husk

	-- harvest accents
	pumpkin    = "#ff9f50",
	squash     = "#ffb56a",
	amber      = "#ffc97a",
	candle     = "#ffd9a0",
	clove      = "#d88b6a",
	cinnamon   = "#c97a5a",
	bark       = "#a77d5b",
	berry      = "#ff6f61",
	vine       = "#9bd27a",
	moss       = "#7fbe6a",
	sage       = "#b6d3a5",
	dusk       = "#b6a5ff", -- cool contrast
	smoke      = "#a7d8ff",

	error      = "#ff6f61",
	warn       = "#ffc97a",
	info       = "#a7d8ff",
	hint       = "#b6d3a5",
}

local function setup(opts)
	if opts then for k, v in pairs(opts) do config[k] = v end end
end

local function hi(g, s) vim.api.nvim_set_hl(0, g, s) end

local function apply()
	if vim.g.colors_name then vim.cmd('hi clear') end
	vim.o.termguicolors = true
	vim.g.colors_name = 'pumpkin-patch'

	local bg = config.transparent and 'NONE' or p.bg

	-- Base UI
	hi('Normal', { fg = p.fg, bg = bg })
	hi('NormalNC', { fg = p.fg_dim, bg = config.dim_inactive and p.bg_alt or bg })
	hi('SignColumn', { bg = bg })
	hi('LineNr', { fg = p.comment, bg = bg })
	hi('CursorLineNr', { fg = p.amber, bold = true, bg = p.cursorline })
	hi('CursorLine', { bg = p.cursorline })
	hi('CursorColumn', { bg = p.cursorline })
	hi('Visual', { bg = p.ui })
	hi('ColorColumn', { bg = p.ui })
	hi('WinSeparator', { fg = p.gutter })
	hi('VertSplit', { fg = p.gutter })
	hi('Folded', { fg = p.dusk, bg = p.bg_alt })
	hi('FoldColumn', { fg = p.comment, bg = bg })
	hi('MatchParen', { bg = p.gutter, bold = true })
	hi('NonText', { fg = p.gutter })
	hi('Whitespace', { fg = p.gutter })
	hi('SpecialKey', { fg = p.gutter })
	hi('Pmenu', { fg = p.fg, bg = p.bg_alt })
	hi('PmenuSel', { fg = p.bg, bg = p.pumpkin, bold = true })
	hi('PmenuSbar', { bg = p.gutter })
	hi('PmenuThumb', { bg = p.dusk })
	hi('Search', { fg = p.bg, bg = p.amber, bold = true })
	hi('IncSearch', { fg = p.bg, bg = p.berry, bold = true })
	hi('WildMenu', { fg = p.bg, bg = p.dusk, bold = true })
	hi('StatusLine', { fg = p.fg, bg = p.bg_alt })
	hi('StatusLineNC', { fg = p.comment, bg = p.bg_alt })
	hi('TabLine', { fg = p.comment, bg = p.bg_alt })
	hi('TabLineSel', { fg = p.bg, bg = p.pumpkin, bold = true })

	-- Syntax
	hi('Comment', { fg = p.comment, italic = config.italics })
	hi('String', { fg = p.sage })
	hi('Character', { fg = p.vine })
	hi('Number', { fg = p.amber })
	hi('Float', { fg = p.amber })
	hi('Boolean', { fg = p.berry })
	hi('Identifier', { fg = p.cinnamon })
	hi('Function', { fg = p.dusk, bold = true })
	hi('Statement', { fg = p.pumpkin })
	hi('Conditional', { fg = p.pumpkin, italic = config.italics })
	hi('Repeat', { fg = p.pumpkin })
	hi('Operator', { fg = p.smoke })
	hi('Keyword', { fg = p.clove, italic = config.italics })
	hi('Exception', { fg = p.berry })
	hi('PreProc', { fg = p.bark })
	hi('Include', { fg = p.bark })
	hi('Define', { fg = p.bark })
	hi('Type', { fg = p.vine })
	hi('StorageClass', { fg = p.vine })
	hi('Structure', { fg = p.vine })
	hi('Typedef', { fg = p.vine })
	hi('Special', { fg = p.amber })
	hi('Delimiter', { fg = p.fg })
	hi('Error', { fg = p.error, bold = true })
	hi('Todo', { fg = p.amber, bold = true, italic = config.italics })

	-- Diagnostics
	hi('DiagnosticError', { fg = p.error })
	hi('DiagnosticWarn', { fg = p.warn })
	hi('DiagnosticInfo', { fg = p.info })
	hi('DiagnosticHint', { fg = p.hint })
	hi('DiagnosticUnderlineError', { sp = p.error, undercurl = true })
	hi('DiagnosticUnderlineWarn', { sp = p.warn, undercurl = true })
	hi('DiagnosticUnderlineInfo', { sp = p.info, undercurl = true })
	hi('DiagnosticUnderlineHint', { sp = p.hint, undercurl = true })

	-- LSP
	hi('LspReferenceText', { bg = p.ui })
	hi('LspReferenceRead', { bg = p.ui })
	hi('LspReferenceWrite', { bg = p.ui })
	hi('LspInlayHint', { fg = p.comment, bg = p.bg_alt, italic = true })
	hi('@lsp.type.parameter', { fg = p.smoke })
	hi('@lsp.type.property', { fg = p.cinnamon })

	-- Treesitter modern/legacy
	local ts = function(name, spec)
		hi(name, spec)
		local legacy = name:gsub('^@', 'TS')
		hi(legacy, spec)
	end

	ts('@comment', { fg = p.comment, italic = config.italics })
	ts('@punctuation', { fg = p.fg })
	ts('@operator', { fg = p.smoke })
	ts('@string', { fg = p.sage })
	ts('@character', { fg = p.vine })
	ts('@number', { fg = p.amber })
	ts('@boolean', { fg = p.berry })
	ts('@constant', { fg = p.candle })
	ts('@constant.builtin', { fg = p.amber, italic = config.italics })
	ts('@variable', { fg = p.fg })
	ts('@variable.builtin', { fg = p.cinnamon, italic = config.italics })
	ts('@field', { fg = p.cinnamon })
	ts('@property', { fg = p.cinnamon })
	ts('@parameter', { fg = p.smoke })
	ts('@function', { fg = p.dusk, bold = true })
	ts('@function.builtin', { fg = p.dusk, italic = config.italics })
	ts('@constructor', { fg = p.bark })
	ts('@type', { fg = p.vine })
	ts('@type.builtin', { fg = p.vine, italic = config.italics })
	ts('@keyword', { fg = p.clove, italic = config.italics })
	ts('@keyword.return', { fg = p.berry, italic = config.italics })
	ts('@conditional', { fg = p.pumpkin })
	ts('@repeat', { fg = p.pumpkin })
	ts('@tag', { fg = p.dusk })
	ts('@attribute', { fg = p.candle })
	ts('@markup.link', { fg = p.smoke, underline = true })
	ts('@markup.strong', { bold = true })
	ts('@markup.italic', { italic = true })
	ts('@markup.heading', { fg = p.dusk, bold = true })

	-- Telescope
	hi('TelescopeNormal', { fg = p.fg, bg = p.bg_alt })
	hi('TelescopeBorder', { fg = p.gutter, bg = p.bg_alt })
	hi('TelescopePromptNormal', { fg = p.fg, bg = p.ui })
	hi('TelescopePromptBorder', { fg = p.gutter, bg = p.ui })
	hi('TelescopeSelection', { fg = p.bg, bg = p.squash, bold = true })

	-- NvimTree / Neo-tree
	hi('NvimTreeNormal', { fg = p.fg, bg = p.bg_alt })
	hi('NvimTreeFolderIcon', { fg = p.dusk })
	hi('NvimTreeFolderName', { fg = p.dusk })
	hi('NvimTreeRootFolder', { fg = p.dusk, bold = true })
	hi('NvimTreeGitDirty', { fg = p.amber })
	hi('NvimTreeGitNew', { fg = p.vine })
	hi('NvimTreeGitDeleted', { fg = p.berry })

	-- Git signs
	hi('GitSignsAdd', { fg = p.vine })
	hi('GitSignsChange', { fg = p.amber })
	hi('GitSignsDelete', { fg = p.berry })

	-- CMP
	hi('CmpItemAbbr', { fg = p.fg })
	hi('CmpItemAbbrMatch', { fg = p.dusk, bold = true })
	hi('CmpItemKind', { fg = p.candle })
	hi('CmpItemMenu', { fg = p.comment })

	-- Treesitter-context
	hi('TreesitterContext', { bg = p.bg_alt })

	-- Illuminate
	hi('IlluminatedWordText', { bg = p.ui })
	hi('IlluminatedWordRead', { bg = p.ui })
	hi('IlluminatedWordWrite', { bg = p.ui })

	-- WhichKey
	hi('WhichKey', { fg = p.dusk })
	hi('WhichKeyGroup', { fg = p.clove })
	hi('WhichKeyDesc', { fg = p.fg })
	hi('WhichKeySeparator', { fg = p.gutter })

	-- Virtual text
	hi('DiagnosticVirtualTextError', { fg = p.error, bg = p.bg_alt })
	hi('DiagnosticVirtualTextWarn', { fg = p.warn, bg = p.bg_alt })
	hi('DiagnosticVirtualTextInfo', { fg = p.info, bg = p.bg_alt })
	hi('DiagnosticVirtualTextHint', { fg = p.hint, bg = p.bg_alt })

	-- Spell
	hi('SpellBad', { sp = p.error, undercurl = true })
	hi('SpellCap', { sp = p.info, undercurl = true })
	hi('SpellLocal', { sp = p.hint, undercurl = true })
	hi('SpellRare', { sp = p.warn, undercurl = true })

	-- Terminal palette
	vim.g.terminal_color_0  = p.bg
	vim.g.terminal_color_1  = p.berry
	vim.g.terminal_color_2  = p.vine
	vim.g.terminal_color_3  = p.amber
	vim.g.terminal_color_4  = p.dusk
	vim.g.terminal_color_5  = p.clove
	vim.g.terminal_color_6  = p.smoke
	vim.g.terminal_color_7  = p.fg
	vim.g.terminal_color_8  = p.gutter
	vim.g.terminal_color_9  = p.berry
	vim.g.terminal_color_10 = p.vine
	vim.g.terminal_color_11 = p.amber
	vim.g.terminal_color_12 = p.dusk
	vim.g.terminal_color_13 = p.clove
	vim.g.terminal_color_14 = p.smoke
	vim.g.terminal_color_15 = p.fg

	-- Diff
	hi('DiffAdd', { bg = '#162313', fg = p.vine })
	hi('DiffChange', { bg = '#2a1e0b', fg = p.amber })
	hi('DiffDelete', { bg = '#2a1212', fg = p.berry })
	hi('DiffText', { bg = '#30250d', fg = p.candle, bold = true })
end

local M = {}
M.setup = setup
M.load = apply

if vim.g.colors_name ~= 'pumpkin-patch' then
	if type(vim.g.pumpkin_patch) == 'table' then setup(vim.g.pumpkin_patch) end
	apply()
end

return M
