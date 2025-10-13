-- File: colors/fairyfloss-nocturne.lua
-- A dark, gothic-esque fairyfloss theme for Neovim
-- Author: you + ChatGPT
-- License: MIT
--
-- Drop this file at: ~/.config/nvim/colors/fairyfloss-nocturne.lua
-- Then run: :colorscheme fairyfloss-nocturne
-- Optional: require("fairyfloss-nocturne").setup{...} before :colorscheme if you place this file under lua/ instead.

local config = {
	transparent = false,
	dim_inactive = true,
	italics = true,
}

-- Pastel-candy accents on a cathedral-dark backdrop
local palette = {
	bg         = "#0b0b10", -- near-black with a hint of indigo
	bg_dim     = "#0e0e15",
	bg_alt     = "#12121a",
	ui         = "#1b1b26",
	gutter     = "#242433",
	cursorline = "#151523",

	fg         = "#e9e3ef", -- soft moonlight
	fg_dim     = "#c9c3cf",
	comment    = "#7a7585", -- weathered stone

	pink       = "#ffb8d1", -- fairyfloss pink
	rose       = "#ff88b3",
	red        = "#ff5c8a",
	purple     = "#c8a1ff",
	violet     = "#a78bfa",
	lilac      = "#bfa6ff",
	blue       = "#8ab6ff",
	cyan       = "#a0f0ff",
	teal       = "#8cf5dd",
	mint       = "#a0ffcf",
	green      = "#9be38a",
	yellow     = "#ffd47e",
	gold       = "#ffcc66",
	orange     = "#ffad66",

	error      = "#ff5c8a",
	warn       = "#ffcc66",
	info       = "#8ab6ff",
	hint       = "#8cf5dd",
}

local function setup(opts)
	if opts then
		for k, v in pairs(opts) do config[k] = v end
	end
end

local function hi(group, spec)
	vim.api.nvim_set_hl(0, group, spec)
end

local function apply()
	if vim.g.colors_name then
		vim.cmd("hi clear")
	end
	vim.o.termguicolors = true
	vim.g.colors_name = "fairyfloss-nocturne"

	local bg = config.transparent and "NONE" or palette.bg

	-- Base UI
	hi("Normal", { fg = palette.fg, bg = bg })
	hi("NormalNC", { fg = palette.fg_dim, bg = config.dim_inactive and palette.bg_alt or bg })
	hi("SignColumn", { bg = bg })
	hi("LineNr", { fg = palette.comment, bg = bg })
	hi("CursorLineNr", { fg = palette.yellow, bold = true, bg = palette.cursorline })
	hi("CursorLine", { bg = palette.cursorline })
	hi("CursorColumn", { bg = palette.cursorline })
	hi("Visual", { bg = palette.ui })
	hi("ColorColumn", { bg = palette.ui })
	hi("WinSeparator", { fg = palette.gutter })
	hi("VertSplit", { fg = palette.gutter })
	hi("Folded", { fg = palette.violet, bg = palette.bg_alt })
	hi("FoldColumn", { fg = palette.comment, bg = bg })
	hi("MatchParen", { bg = palette.gutter, bold = true })
	hi("NonText", { fg = palette.gutter })
	hi("Whitespace", { fg = palette.gutter })
	hi("SpecialKey", { fg = palette.gutter })
	hi("Pmenu", { fg = palette.fg, bg = palette.bg_alt })
	hi("PmenuSel", { fg = palette.bg, bg = palette.pink, bold = true })
	hi("PmenuSbar", { bg = palette.gutter })
	hi("PmenuThumb", { bg = palette.violet })
	hi("Search", { fg = palette.bg, bg = palette.gold, bold = true })
	hi("IncSearch", { fg = palette.bg, bg = palette.rose, bold = true })
	hi("WildMenu", { fg = palette.bg, bg = palette.purple, bold = true })
	hi("StatusLine", { fg = palette.fg, bg = palette.bg_alt })
	hi("StatusLineNC", { fg = palette.comment, bg = palette.bg_alt })
	hi("TabLine", { fg = palette.comment, bg = palette.bg_alt })
	hi("TabLineSel", { fg = palette.bg, bg = palette.purple, bold = true })

	-- Syntax (Vim)
	hi("Comment", { fg = palette.comment, italic = config.italics })
	hi("String", { fg = palette.mint })
	hi("Character", { fg = palette.teal })
	hi("Number", { fg = palette.gold })
	hi("Float", { fg = palette.gold })
	hi("Boolean", { fg = palette.rose })
	hi("Identifier", { fg = palette.pink })
	hi("Function", { fg = palette.lilac, bold = true })
	hi("Statement", { fg = palette.violet })
	hi("Conditional", { fg = palette.violet, italic = config.italics })
	hi("Repeat", { fg = palette.violet })
	hi("Operator", { fg = palette.cyan })
	hi("Keyword", { fg = palette.purple, italic = config.italics })
	hi("Exception", { fg = palette.rose })
	hi("PreProc", { fg = palette.blue })
	hi("Include", { fg = palette.blue })
	hi("Define", { fg = palette.blue })
	hi("Type", { fg = palette.green })
	hi("StorageClass", { fg = palette.green })
	hi("Structure", { fg = palette.green })
	hi("Typedef", { fg = palette.green })
	hi("Special", { fg = palette.yellow })
	hi("Delimiter", { fg = palette.fg })
	hi("Error", { fg = palette.error, bold = true })
	hi("Todo", { fg = palette.gold, bold = true, italic = config.italics })

	-- Diagnostic
	hi("DiagnosticError", { fg = palette.error })
	hi("DiagnosticWarn", { fg = palette.warn })
	hi("DiagnosticInfo", { fg = palette.info })
	hi("DiagnosticHint", { fg = palette.hint })
	hi("DiagnosticUnderlineError", { sp = palette.error, undercurl = true })
	hi("DiagnosticUnderlineWarn", { sp = palette.warn, undercurl = true })
	hi("DiagnosticUnderlineInfo", { sp = palette.info, undercurl = true })
	hi("DiagnosticUnderlineHint", { sp = palette.hint, undercurl = true })

	-- LSP
	hi("LspReferenceText", { bg = palette.ui })
	hi("LspReferenceRead", { bg = palette.ui })
	hi("LspReferenceWrite", { bg = palette.ui })
	hi("LspInlayHint", { fg = palette.comment, bg = palette.bg_alt, italic = true })
	hi("@lsp.type.parameter", { fg = palette.cyan })
	hi("@lsp.type.property", { fg = palette.pink })

	-- TreeSitter (modern '@' captures) + legacy TS*
	local ts = function(name, spec)
		hi(name, spec)
		local legacy = name:gsub('^@', 'TS')
		hi(legacy, spec)
	end

	ts("@comment", { fg = palette.comment, italic = config.italics })
	ts("@punctuation", { fg = palette.fg })
	ts("@operator", { fg = palette.cyan })
	ts("@string", { fg = palette.mint })
	ts("@character", { fg = palette.teal })
	ts("@number", { fg = palette.gold })
	ts("@boolean", { fg = palette.rose })
	ts("@constant", { fg = palette.yellow })
	ts("@constant.builtin", { fg = palette.gold, italic = config.italics })
	ts("@variable", { fg = palette.fg })
	ts("@variable.builtin", { fg = palette.pink, italic = config.italics })
	ts("@field", { fg = palette.pink })
	ts("@property", { fg = palette.pink })
	ts("@parameter", { fg = palette.cyan })
	ts("@function", { fg = palette.lilac, bold = true })
	ts("@function.builtin", { fg = palette.violet, italic = config.italics })
	ts("@constructor", { fg = palette.blue })
	ts("@type", { fg = palette.green })
	ts("@type.builtin", { fg = palette.green, italic = config.italics })
	ts("@keyword", { fg = palette.purple, italic = config.italics })
	ts("@keyword.return", { fg = palette.rose, italic = config.italics })
	ts("@conditional", { fg = palette.violet })
	ts("@repeat", { fg = palette.violet })
	ts("@tag", { fg = palette.blue })
	ts("@attribute", { fg = palette.yellow })
	ts("@markup.link", { fg = palette.cyan, underline = true })
	ts("@markup.strong", { bold = true })
	ts("@markup.italic", { italic = true })
	ts("@markup.heading", { fg = palette.lilac, bold = true })

	-- Plugins
	-- Telescope
	hi("TelescopeNormal", { fg = palette.fg, bg = palette.bg_alt })
	hi("TelescopeBorder", { fg = palette.gutter, bg = palette.bg_alt })
	hi("TelescopePromptNormal", { fg = palette.fg, bg = palette.ui })
	hi("TelescopePromptBorder", { fg = palette.gutter, bg = palette.ui })
	hi("TelescopeSelection", { fg = palette.bg, bg = palette.pink, bold = true })

	-- NvimTree / Neo-tree
	hi("NvimTreeNormal", { fg = palette.fg, bg = palette.bg_alt })
	hi("NvimTreeFolderIcon", { fg = palette.violet })
	hi("NvimTreeFolderName", { fg = palette.violet })
	hi("NvimTreeRootFolder", { fg = palette.lilac, bold = true })
	hi("NvimTreeGitDirty", { fg = palette.gold })
	hi("NvimTreeGitNew", { fg = palette.green })
	hi("NvimTreeGitDeleted", { fg = palette.red })

	-- Git signs
	hi("GitSignsAdd", { fg = palette.green })
	hi("GitSignsChange", { fg = palette.gold })
	hi("GitSignsDelete", { fg = palette.red })

	-- CMP
	hi("CmpItemAbbr", { fg = palette.fg })
	hi("CmpItemAbbrMatch", { fg = palette.lilac, bold = true })
	hi("CmpItemKind", { fg = palette.yellow })
	hi("CmpItemMenu", { fg = palette.comment })

	-- Treesitter-context
	hi("TreesitterContext", { bg = palette.bg_alt })

	-- Illuminate
	hi("IlluminatedWordText", { bg = palette.ui })
	hi("IlluminatedWordRead", { bg = palette.ui })
	hi("IlluminatedWordWrite", { bg = palette.ui })

	-- WhichKey
	hi("WhichKey", { fg = palette.lilac })
	hi("WhichKeyGroup", { fg = palette.violet })
	hi("WhichKeyDesc", { fg = palette.fg })
	hi("WhichKeySeparator", { fg = palette.gutter })

	-- Diagnostics virtual text background subtle
	hi("DiagnosticVirtualTextError", { fg = palette.error, bg = palette.bg_alt })
	hi("DiagnosticVirtualTextWarn", { fg = palette.warn, bg = palette.bg_alt })
	hi("DiagnosticVirtualTextInfo", { fg = palette.info, bg = palette.bg_alt })
	hi("DiagnosticVirtualTextHint", { fg = palette.hint, bg = palette.bg_alt })

	-- Spell
	hi("SpellBad", { sp = palette.error, undercurl = true })
	hi("SpellCap", { sp = palette.info, undercurl = true })
	hi("SpellLocal", { sp = palette.hint, undercurl = true })
	hi("SpellRare", { sp = palette.warn, undercurl = true })

	-- Terminal palette (good defaults for :terminal)
	vim.g.terminal_color_0  = palette.bg
	vim.g.terminal_color_1  = palette.red
	vim.g.terminal_color_2  = palette.green
	vim.g.terminal_color_3  = palette.gold
	vim.g.terminal_color_4  = palette.blue
	vim.g.terminal_color_5  = palette.purple
	vim.g.terminal_color_6  = palette.teal
	vim.g.terminal_color_7  = palette.fg
	vim.g.terminal_color_8  = palette.gutter
	vim.g.terminal_color_9  = palette.rose
	vim.g.terminal_color_10 = palette.green
	vim.g.terminal_color_11 = palette.yellow
	vim.g.terminal_color_12 = palette.blue
	vim.g.terminal_color_13 = palette.violet
	vim.g.terminal_color_14 = palette.cyan
	vim.g.terminal_color_15 = palette.fg

	-- Diff
	hi("DiffAdd", { bg = "#10331d", fg = palette.green })
	hi("DiffChange", { bg = "#2a1d0a", fg = palette.gold })
	hi("DiffDelete", { bg = "#311018", fg = palette.red })
	hi("DiffText", { bg = "#332208", fg = palette.yellow, bold = true })
end

-- If this file is placed under colors/, Neovim will call it directly.
-- If it's in lua/ somewhere, you can do: require('fairyfloss-nocturne').setup{...}; vim.cmd('colorscheme fairyfloss-nocturne')

local M = {}
M.setup = setup
M.load = apply

-- Entry point when used as :colorscheme
if vim.g.colors_name ~= "fairyfloss-nocturne" then
	-- Allow users to pre-configure via: vim.g.fairyfloss_nocturne = { transparent = true, ... }
	if type(vim.g.fairyfloss_nocturne) == "table" then
		setup(vim.g.fairyfloss_nocturne)
	end
	apply()
end

return M
