-- Sonoran Sun — a warm desert-inspired colorscheme for Neovim
-- File: colors/sonoran-sun.lua
-- License: MIT

local M = {}

-- Palette — desert dusk with sun-baked accents
local p = {
	bg       = "#1b1a17", -- canyon shadow
	bg_alt   = "#211f1c",
	surface  = "#2a2825",
	surface2 = "#332f2a",
	overlay  = "#3a342e",
	muted    = "#6e655a",
	text     = "#e6d5b8", -- bleached sandstone
	subtext  = "#d9c7a7",

	sun      = "#f4a261", -- sun orange
	burnt    = "#e76f51", -- canyon red/orange
	cactus   = "#2a9d8f", -- cactus teal
	sky      = "#457b9d", -- high desert sky
	sage     = "#94d2bd", -- pale green
	purple   = "#6a4c93", -- twilight
	yellow   = "#ffd166",
	red      = "#ef476f",

	-- diagnostics / vcs
	add      = "#3fa27a",
	change   = "#b07d2e",
	delete   = "#c94c4c",
}

local function hi(group, opts)
	vim.api.nvim_set_hl(0, group, opts)
end

local function link(from, to)
	vim.api.nvim_set_hl(0, from, { link = to })
end

local function setup_term()
	vim.g.terminal_color_0  = p.bg
	vim.g.terminal_color_1  = p.red
	vim.g.terminal_color_2  = p.cactus
	vim.g.terminal_color_3  = p.yellow
	vim.g.terminal_color_4  = p.sky
	vim.g.terminal_color_5  = p.purple
	vim.g.terminal_color_6  = p.sage
	vim.g.terminal_color_7  = p.text
	vim.g.terminal_color_8  = p.surface
	vim.g.terminal_color_9  = p.burnt
	vim.g.terminal_color_10 = p.add
	vim.g.terminal_color_11 = p.sun
	vim.g.terminal_color_12 = p.sky
	vim.g.terminal_color_13 = p.purple
	vim.g.terminal_color_14 = p.sage
	vim.g.terminal_color_15 = p.subtext
end

local function syntax()
	-- Editor UI
	hi("Normal", { fg = p.text, bg = p.bg })
	hi("NormalNC", { fg = p.subtext, bg = p.bg })
	hi("NormalFloat", { fg = p.text, bg = p.bg_alt })
	hi("FloatBorder", { fg = p.overlay, bg = p.bg_alt })
	hi("WinSeparator", { fg = p.surface2, bg = p.bg })
	hi("SignColumn", { bg = p.bg })
	hi("LineNr", { fg = p.muted, bg = p.bg })
	hi("CursorLine", { bg = p.surface })
	hi("CursorLineNr", { fg = p.sun, bold = true })
	hi("Visual", { bg = p.surface2 })
	hi("Search", { fg = p.bg, bg = p.sun, bold = true })
	hi("IncSearch", { fg = p.bg, bg = p.burnt, bold = true })
	hi("MatchParen", { fg = p.yellow, bold = true })
	hi("Pmenu", { fg = p.text, bg = p.surface })
	hi("PmenuSel", { fg = p.bg, bg = p.sun, bold = true })
	hi("PmenuSbar", { bg = p.surface2 })
	hi("PmenuThumb", { bg = p.overlay })
	hi("StatusLine", { fg = p.text, bg = p.surface })
	hi("StatusLineNC", { fg = p.muted, bg = p.surface })
	hi("TabLine", { fg = p.muted, bg = p.surface })
	hi("TabLineSel", { fg = p.bg, bg = p.sun, bold = true })
	hi("TabLineFill", { bg = p.surface })
	hi("VertSplit", { fg = p.surface2 })
	hi("Directory", { fg = p.cactus })
	hi("Title", { fg = p.sun, bold = true })
	hi("ErrorMsg", { fg = p.bg, bg = p.red, bold = true })
	hi("WarningMsg", { fg = p.bg, bg = p.change, bold = true })
	hi("Todo", { fg = p.bg, bg = p.yellow, bold = true })

	-- Standard syntax
	hi("Comment", { fg = p.muted, italic = true })
	hi("Constant", { fg = p.sun })
	hi("String", { fg = p.sage })
	hi("Character", { fg = p.sage })
	hi("Number", { fg = p.yellow })
	hi("Boolean", { fg = p.burnt })
	hi("Float", { fg = p.yellow })
	hi("Identifier", { fg = p.text })
	hi("Function", { fg = p.sun, bold = true })
	hi("Statement", { fg = p.burnt })
	hi("Conditional", { fg = p.purple })
	hi("Repeat", { fg = p.purple })
	hi("Label", { fg = p.sun })
	hi("Operator", { fg = p.sky })
	hi("Keyword", { fg = p.burnt, italic = true })
	hi("Exception", { fg = p.red })
	hi("PreProc", { fg = p.sky })
	hi("Include", { fg = p.sky })
	hi("Define", { fg = p.sky })
	hi("Macro", { fg = p.sky })
	hi("PreCondit", { fg = p.sky })
	hi("Type", { fg = p.cactus })
	hi("StorageClass", { fg = p.cactus })
	hi("Structure", { fg = p.cactus })
	hi("Typedef", { fg = p.cactus })
	hi("Special", { fg = p.sun })
	hi("SpecialComment", { fg = p.muted, italic = true })
	hi("Underlined", { underline = true })

	-- Diff / Git
	hi("DiffAdd", { bg = "#16352a", fg = p.add })
	hi("DiffChange", { bg = "#3a2e19", fg = p.change })
	hi("DiffDelete", { bg = "#3a1e22", fg = p.delete })
	hi("DiffText", { bg = "#5a4121", fg = p.sun, bold = true })

	-- GitSigns (if installed)
	hi("GitSignsAdd", { fg = p.add })
	hi("GitSignsChange", { fg = p.change })
	hi("GitSignsDelete", { fg = p.delete })

	-- Diagnostics
	hi("DiagnosticError", { fg = p.red })
	hi("DiagnosticWarn", { fg = p.sun })
	hi("DiagnosticInfo", { fg = p.sky })
	hi("DiagnosticHint", { fg = p.sage })
	hi("DiagnosticOk", { fg = p.add })
	hi("DiagnosticUnderlineError", { undercurl = true, sp = p.red })
	hi("DiagnosticUnderlineWarn", { undercurl = true, sp = p.sun })
	hi("DiagnosticUnderlineInfo", { undercurl = true, sp = p.sky })
	hi("DiagnosticUnderlineHint", { undercurl = true, sp = p.sage })
	hi("DiagnosticVirtualTextError", { fg = p.red, bg = p.surface })
	hi("DiagnosticVirtualTextWarn", { fg = p.sun, bg = p.surface })
	hi("DiagnosticVirtualTextInfo", { fg = p.sky, bg = p.surface })
	hi("DiagnosticVirtualTextHint", { fg = p.sage, bg = p.surface })
	hi("LspReferenceText", { bg = p.surface2 })
	hi("LspReferenceRead", { bg = p.surface2 })
	hi("LspReferenceWrite", { bg = p.surface2 })

	-- Treesitter (newer names)
	hi("@comment", { fg = p.muted, italic = true })
	hi("@punctuation", { fg = p.overlay })
	hi("@operator", { fg = p.sky })
	hi("@property", { fg = p.text })
	hi("@field", { fg = p.text })
	hi("@variable", { fg = p.text })
	hi("@variable.builtin", { fg = p.sky, italic = true })
	hi("@constant", { fg = p.sun })
	hi("@constant.builtin", { fg = p.burnt })
	hi("@string", { fg = p.sage })
	hi("@string.escape", { fg = p.yellow })
	hi("@number", { fg = p.yellow })
	hi("@boolean", { fg = p.burnt })
	hi("@type", { fg = p.cactus })
	hi("@type.builtin", { fg = p.cactus, italic = true })
	hi("@function", { fg = p.sun, bold = true })
	hi("@function.builtin", { fg = p.sun, italic = true })
	hi("@constructor", { fg = p.sky })
	hi("@keyword", { fg = p.burnt, italic = true })
	hi("@keyword.return", { fg = p.burnt, bold = true })
	hi("@conditional", { fg = p.purple })
	hi("@repeat", { fg = p.purple })
	hi("@exception", { fg = p.red })
	hi("@parameter", { fg = p.text, italic = true })
	hi("@namespace", { fg = p.sky })

	-- Telescope
	hi("TelescopeNormal", { fg = p.text, bg = p.bg_alt })
	hi("TelescopeBorder", { fg = p.overlay, bg = p.bg_alt })
	hi("TelescopeTitle", { fg = p.bg, bg = p.sun, bold = true })
	hi("TelescopeSelection", { fg = p.bg, bg = p.sun, bold = true })
	hi("TelescopeMatching", { fg = p.yellow, bold = true })

	-- Neo-tree (nvim-neo-tree/neo-tree.nvim)
	hi("NeoTreeNormal", { fg = p.text, bg = p.bg_alt })
	hi("NeoTreeNormalNC", { fg = p.subtext, bg = p.bg_alt })
	hi("NeoTreeWinSeparator", { fg = p.surface2, bg = p.bg_alt })
	hi("NeoTreeStatusLine", { fg = p.text, bg = p.surface })
	hi("NeoTreeStatusLineNC", { fg = p.muted, bg = p.surface })
	hi("NeoTreeCursorLine", { bg = p.surface })
	hi("NeoTreeIndentMarker", { fg = p.overlay })
	hi("NeoTreeExpander", { fg = p.overlay })
	hi("NeoTreeRootName", { fg = p.sun, bold = true })
	hi("NeoTreeDirectoryName", { fg = p.cactus, bold = true })
	hi("NeoTreeDirectoryIcon", { fg = p.cactus })
	hi("NeoTreeFileName", { fg = p.text })
	hi("NeoTreeFileNameOpened", { fg = p.sun })
	hi("NeoTreeSymbolicLinkTarget", { fg = p.sky, italic = true })

	-- Neo-tree git/status
	hi("NeoTreeGitAdded", { fg = p.add })
	hi("NeoTreeGitDeleted", { fg = p.delete })
	hi("NeoTreeGitModified", { fg = p.change })
	hi("NeoTreeGitRenamed", { fg = p.sky })
	hi("NeoTreeGitUntracked", { fg = p.sage })
	hi("NeoTreeGitIgnored", { fg = p.muted, italic = true })
	hi("NeoTreeGitConflict", { fg = p.red, bold = true })

	-- Neo-tree diagnostics
	hi("NeoTreeDiagnosticError", { fg = p.red })
	hi("NeoTreeDiagnosticWarn", { fg = p.sun })
	hi("NeoTreeDiagnosticInfo", { fg = p.sky })
	hi("NeoTreeDiagnosticHint", { fg = p.sage })

	-- Neo-tree floats & tabs
	hi("NeoTreeFloatTitle", { fg = p.bg, bg = p.sun, bold = true })
	hi("NeoTreeFloatBorder", { fg = p.overlay, bg = p.bg_alt })
	hi("NeoTreeTabActive", { fg = p.bg, bg = p.sun, bold = true })
	hi("NeoTreeTabInactive", { fg = p.muted, bg = p.surface })
	hi("NeoTreeTabSeparatorActive", { fg = p.sun })
	hi("NeoTreeTabSeparatorInactive", { fg = p.surface2 })

	-- WhichKey (popular)
	hi("WhichKey", { fg = p.sun })
	hi("WhichKeyGroup", { fg = p.cactus })
	hi("WhichKeyDesc", { fg = p.text })
	hi("WhichKeyFloat", { bg = p.bg_alt })

	-- Make floating pop a bit
	hi("FloatTitle", { fg = p.bg, bg = p.sun, bold = true })
end

function M.load()
	if vim.g.colors_name then
		vim.cmd("hi clear")
	end
	if vim.fn.has("termguicolors") == 1 then
		vim.o.termguicolors = true
	end
	vim.g.colors_name = "sonoran-sun"
	setup_term()
	syntax()
end

-- Allow :colorscheme sonoran-sun to call this file directly
M.load()

return M
