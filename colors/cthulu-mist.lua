-- File: colors/cthulhu-mist.lua
-- A slightly lighter, abyssal-sea (Cthulhu) themed Neovim colorscheme
-- License: MIT
--
-- Install: place at ~/.config/nvim/colors/cthulhu-mist.lua
-- :colorscheme cthulhu-mist

local config = {
	transparent = false,
	dim_inactive = false,
	italics = true,
}

-- Misty abyss palette: sea-teals, eldritch greens, phosphor glows
local p = {
	-- a touch lighter than deep-black, with blue-green cast
	bg         = "#0f1416",
	bg_dim     = "#12191c",
	bg_alt     = "#162024",
	ui         = "#1b2a2f",
	gutter     = "#24363b",
	cursorline = "#152025",

	fg         = "#e2efe9", -- foggy lantern light
	fg_dim     = "#c8dad3",
	comment    = "#7c9590", -- damp stone moss

	-- eldritch accents
	slime      = "#a8f5bf", -- phosphorescent slime
	seafoam    = "#8fe3c4",
	kelp       = "#6fd0a3",
	abyss      = "#68c3c0",
	brine      = "#57b2b0",
	coral      = "#ffb39a",
	warning    = "#e6d37a",
	gold       = "#dfc16a",
	ember      = "#ff9777",
	blood      = "#ff6e7a",
	violet     = "#b0a5ff",
	twilight   = "#9bb0ff",
	cyan       = "#9de8ff",
	mint       = "#b3ffd8",

	error      = "#ff6e7a",
	warn       = "#e6d37a",
	info       = "#9de8ff",
	hint       = "#8fe3c4",
}

local function setup(opts)
	if opts then for k, v in pairs(opts) do config[k] = v end end
end

local function hi(g, s) vim.api.nvim_set_hl(0, g, s) end

local function apply()
	if vim.g.colors_name then vim.cmd('hi clear') end
	vim.o.termguicolors = true
	vim.g.colors_name = 'cthulhu-mist'

	local bg = config.transparent and 'NONE' or p.bg

	-- Base UI
	hi('Normal', { fg = p.fg, bg = bg })
	hi('NormalNC', { fg = p.fg_dim, bg = config.dim_inactive and p.bg_alt or bg })
	hi('SignColumn', { bg = bg })
	hi('LineNr', { fg = p.comment, bg = bg })
	hi('CursorLineNr', { fg = p.warning, bold = true, bg = p.cursorline })
	hi('CursorLine', { bg = p.cursorline })
	hi('CursorColumn', { bg = p.cursorline })
	hi('Visual', { bg = p.ui })
	hi('ColorColumn', { bg = p.ui })
	hi('WinSeparator', { fg = p.gutter })
	hi('VertSplit', { fg = p.gutter })
	hi('Folded', { fg = p.twilight, bg = p.bg_alt })
	hi('FoldColumn', { fg = p.comment, bg = bg })
	hi('MatchParen', { bg = p.gutter, bold = true })
	hi('NonText', { fg = p.gutter })
	hi('Whitespace', { fg = p.gutter })
	hi('SpecialKey', { fg = p.gutter })
	hi('Pmenu', { fg = p.fg, bg = p.bg_alt })
	hi('PmenuSel', { fg = p.bg, bg = p.slime, bold = true })
	hi('PmenuSbar', { bg = p.gutter })
	hi('PmenuThumb', { bg = p.twilight })
	hi('Search', { fg = p.bg, bg = p.gold, bold = true })
	hi('IncSearch', { fg = p.bg, bg = p.ember, bold = true })
	hi('WildMenu', { fg = p.bg, bg = p.violet, bold = true })
	hi('StatusLine', { fg = p.fg, bg = p.bg_alt })
	hi('StatusLineNC', { fg = p.comment, bg = p.bg_alt })
	hi('TabLine', { fg = p.comment, bg = p.bg_alt })
	hi('TabLineSel', { fg = p.bg, bg = p.abyss, bold = true })

	-- Syntax (Vim)
	hi('Comment', { fg = p.comment, italic = config.italics })
	hi('String', { fg = p.mint })
	hi('Character', { fg = p.seafoam })
	hi('Number', { fg = p.gold })
	hi('Float', { fg = p.gold })
	hi('Boolean', { fg = p.coral })
	hi('Identifier', { fg = p.kelp })
	hi('Function', { fg = p.twilight, bold = true })
	hi('Statement', { fg = p.abyss })
	hi('Conditional', { fg = p.abyss, italic = config.italics })
	hi('Repeat', { fg = p.abyss })
	hi('Operator', { fg = p.cyan })
	hi('Keyword', { fg = p.violet, italic = config.italics })
	hi('Exception', { fg = p.blood })
	hi('PreProc', { fg = p.brine })
	hi('Include', { fg = p.brine })
	hi('Define', { fg = p.brine })
	hi('Type', { fg = p.kelp })
	hi('StorageClass', { fg = p.kelp })
	hi('Structure', { fg = p.kelp })
	hi('Typedef', { fg = p.kelp })
	hi('Special', { fg = p.warning })
	hi('Delimiter', { fg = p.fg })
	hi('Error', { fg = p.error, bold = true })
	hi('Todo', { fg = p.gold, bold = true, italic = config.italics })

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
	hi('@lsp.type.parameter', { fg = p.cyan })
	hi('@lsp.type.property', { fg = p.kelp })

	-- Treesitter modern/legacy
	local ts = function(name, spec)
		hi(name, spec)
		local legacy = name:gsub('^@', 'TS')
		hi(legacy, spec)
	end

	ts('@comment', { fg = p.comment, italic = config.italics })
	ts('@punctuation', { fg = p.fg })
	ts('@operator', { fg = p.cyan })
	ts('@string', { fg = p.mint })
	ts('@character', { fg = p.seafoam })
	ts('@number', { fg = p.gold })
	ts('@boolean', { fg = p.coral })
	ts('@constant', { fg = p.warning })
	ts('@constant.builtin', { fg = p.gold, italic = config.italics })
	ts('@variable', { fg = p.fg })
	ts('@variable.builtin', { fg = p.kelp, italic = config.italics })
	ts('@field', { fg = p.kelp })
	ts('@property', { fg = p.kelp })
	ts('@parameter', { fg = p.cyan })
	ts('@function', { fg = p.twilight, bold = true })
	ts('@function.builtin', { fg = p.violet, italic = config.italics })
	ts('@constructor', { fg = p.brine })
	ts('@type', { fg = p.kelp })
	ts('@type.builtin', { fg = p.kelp, italic = config.italics })
	ts('@keyword', { fg = p.violet, italic = config.italics })
	ts('@keyword.return', { fg = p.coral, italic = config.italics })
	ts('@conditional', { fg = p.abyss })
	ts('@repeat', { fg = p.abyss })
	ts('@tag', { fg = p.twilight })
	ts('@attribute', { fg = p.warning })
	ts('@markup.link', { fg = p.cyan, underline = true })
	ts('@markup.strong', { bold = true })
	ts('@markup.italic', { italic = true })
	ts('@markup.heading', { fg = p.twilight, bold = true })

	-- Telescope
	hi('TelescopeNormal', { fg = p.fg, bg = p.bg_alt })
	hi('TelescopeBorder', { fg = p.gutter, bg = p.bg_alt })
	hi('TelescopePromptNormal', { fg = p.fg, bg = p.ui })
	hi('TelescopePromptBorder', { fg = p.gutter, bg = p.ui })
	hi('TelescopeSelection', { fg = p.bg, bg = p.seafoam, bold = true })

	-- NvimTree / Neo-tree
	hi('NvimTreeNormal', { fg = p.fg, bg = p.bg_alt })
	hi('NvimTreeFolderIcon', { fg = p.twilight })
	hi('NvimTreeFolderName', { fg = p.twilight })
	hi('NvimTreeRootFolder', { fg = p.violet, bold = true })
	hi('NvimTreeGitDirty', { fg = p.gold })
	hi('NvimTreeGitNew', { fg = p.kelp })
	hi('NvimTreeGitDeleted', { fg = p.blood })

	-- Git signs
	hi('GitSignsAdd', { fg = p.kelp })
	hi('GitSignsChange', { fg = p.gold })
	hi('GitSignsDelete', { fg = p.blood })

	-- CMP
	hi('CmpItemAbbr', { fg = p.fg })
	hi('CmpItemAbbrMatch', { fg = p.twilight, bold = true })
	hi('CmpItemKind', { fg = p.warning })
	hi('CmpItemMenu', { fg = p.comment })

	-- Treesitter-context
	hi('TreesitterContext', { bg = p.bg_alt })

	-- Illuminate
	hi('IlluminatedWordText', { bg = p.ui })
	hi('IlluminatedWordRead', { bg = p.ui })
	hi('IlluminatedWordWrite', { bg = p.ui })

	-- WhichKey
	hi('WhichKey', { fg = p.twilight })
	hi('WhichKeyGroup', { fg = p.violet })
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
	vim.g.terminal_color_1  = p.blood
	vim.g.terminal_color_2  = p.kelp
	vim.g.terminal_color_3  = p.gold
	vim.g.terminal_color_4  = p.twilight
	vim.g.terminal_color_5  = p.violet
	vim.g.terminal_color_6  = p.abyss
	vim.g.terminal_color_7  = p.fg
	vim.g.terminal_color_8  = p.gutter
	vim.g.terminal_color_9  = p.blood
	vim.g.terminal_color_10 = p.kelp
	vim.g.terminal_color_11 = p.warning
	vim.g.terminal_color_12 = p.twilight
	vim.g.terminal_color_13 = p.violet
	vim.g.terminal_color_14 = p.cyan
	vim.g.terminal_color_15 = p.fg

	-- Diff tones (kelp/amber/blood on sea)
	hi('DiffAdd', { bg = '#0e231b', fg = p.kelp })
	hi('DiffChange', { bg = '#221d0a', fg = p.gold })
	hi('DiffDelete', { bg = '#2a0f13', fg = p.blood })
	hi('DiffText', { bg = '#2b2a0f', fg = p.warning, bold = true })
end

local M = {}
M.setup = setup
M.load = apply

if vim.g.colors_name ~= 'cthulhu-mist' then
	if type(vim.g.cthulhu_mist) == 'table' then setup(vim.g.cthulhu_mist) end
	apply()
end

return M
