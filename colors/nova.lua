-- Name: Neovim Nova
-- Description: A color theme inspired by the JWST Cosmic Cliffs (Carina Nebula)
-- Background: Dark & Light supported

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
	vim.cmd("syntax reset")
end

vim.g.colors_name = "nova"

-- ==========================================
-- Palettes
-- ==========================================

local palettes = {
	dark = {
		bg         = "#0A1128", -- Deep Space Blue
		bg_float   = "#111832", -- Slightly lighter
		bg_visual  = "#2A365C", -- Selection color
		fg         = "#E0E6ED", -- Starlight White
		fg_dim     = "#A1B0C4", -- Distant Stars
		comment    = "#6B7280", -- Dim Dust

		orange     = "#E67E22", -- Cosmic Cliff Dust
		gold       = "#F1C40F", -- Star Gold
		blue_light = "#BBDEFB", -- Comet Blue
		violet     = "#C7D2FE", -- Violet Star
		red        = "#E74C3C", -- High Energy
		cyan       = "#48C9B0", -- Ionized Gas
		pink       = "#D7BDE2", -- Nebula Hues
	},
	light = {
		bg         = "#F4F1EA", -- Pale Illuminated Dust
		bg_float   = "#FFFFFF", -- Pure White
		bg_visual  = "#D5D8DC", -- Darker selection
		fg         = "#1B263B", -- Deep Space Black/Blue Text
		fg_dim     = "#5C6D7E", -- Dimmed Text
		comment    = "#839192", -- Grey Dust

		orange     = "#D35400", -- Deep Orange (for contrast)
		gold       = "#B8860B", -- Dark Goldenrod
		blue_light = "#2980B9", -- Strong Comet Blue
		violet     = "#6C3483", -- Deep Violet
		red        = "#C0392B", -- Deep Red
		cyan       = "#117A65", -- Deep Cyan
		pink       = "#9B59B6", -- Deep Magenta
	}
}

-- Determine which palette to use based on the current background setting
local theme = vim.o.background
local colors = palettes[theme] or palettes.dark

-- Helper function to set highlights
local function hl(group, opts)
	vim.api.nvim_set_hl(0, group, opts)
end

-- ==========================================
-- Editor Highlights
-- ==========================================
hl("Normal", { fg = colors.fg, bg = colors.bg })
hl("NormalFloat", { fg = colors.fg, bg = colors.bg_float })
hl("ColorColumn", { bg = colors.bg_float })
hl("Cursor", { fg = colors.bg, bg = colors.fg })
hl("CursorLine", { bg = colors.bg_float })
hl("CursorColumn", { bg = colors.bg_float })
hl("Directory", { fg = colors.blue_light })
hl("DiffAdd", { fg = colors.cyan, bg = colors.bg_float })
hl("DiffChange", { fg = colors.gold, bg = colors.bg_float })
hl("DiffDelete", { fg = colors.red, bg = colors.bg_float })
hl("DiffText", { fg = colors.bg, bg = colors.gold })
hl("EndOfBuffer", { fg = colors.bg })
hl("ErrorMsg", { fg = colors.red, bold = true })
hl("VertSplit", { fg = colors.comment, bg = colors.bg })
hl("Folded", { fg = colors.comment, bg = colors.bg_float })
hl("IncSearch", { fg = colors.bg, bg = colors.orange })
hl("Search", { fg = colors.bg, bg = colors.gold })
hl("LineNr", { fg = colors.comment })
hl("CursorLineNr", { fg = colors.gold, bold = true })
hl("MatchParen", { fg = colors.orange, bg = colors.bg_float, bold = true })
hl("NonText", { fg = colors.comment })
hl("Pmenu", { fg = colors.fg, bg = colors.bg_float })
hl("PmenuSel", { fg = colors.bg, bg = colors.blue_light })
hl("Visual", { bg = colors.bg_visual })
hl("WarningMsg", { fg = colors.orange })

-- ==========================================
-- Standard Syntax Highlights
-- ==========================================
hl("Comment", { fg = colors.comment, italic = true })
hl("Constant", { fg = colors.pink })
hl("String", { fg = colors.gold })
hl("Character", { fg = colors.gold })
hl("Number", { fg = colors.pink })
hl("Boolean", { fg = colors.pink })
hl("Float", { fg = colors.pink })

hl("Identifier", { fg = colors.violet })
hl("Function", { fg = colors.blue_light, bold = true })

hl("Statement", { fg = colors.orange })
hl("Conditional", { fg = colors.orange })
hl("Repeat", { fg = colors.orange })
hl("Label", { fg = colors.orange })
hl("Operator", { fg = colors.fg_dim })
hl("Keyword", { fg = colors.orange, italic = true })
hl("Exception", { fg = colors.red })

hl("PreProc", { fg = colors.cyan })
hl("Include", { fg = colors.cyan })
hl("Define", { fg = colors.cyan })
hl("Macro", { fg = colors.cyan })
hl("PreCondit", { fg = colors.cyan })

hl("Type", { fg = colors.cyan })
hl("StorageClass", { fg = colors.orange })
hl("Structure", { fg = colors.cyan })
hl("Typedef", { fg = colors.cyan })

hl("Special", { fg = colors.violet })
hl("SpecialChar", { fg = colors.pink })
hl("Tag", { fg = colors.orange })
hl("Delimiter", { fg = colors.fg_dim })
hl("SpecialComment", { fg = colors.comment, bold = true })
hl("Debug", { fg = colors.red })

hl("Underlined", { underline = true })
hl("Ignore", { fg = colors.comment })
hl("Error", { fg = colors.red, bg = colors.bg_float, bold = true })
hl("Todo", { fg = colors.bg, bg = colors.gold, bold = true })

-- ==========================================
-- Treesitter Integration
-- ==========================================
hl("@variable", { fg = colors.fg })
hl("@function", { fg = colors.blue_light })
hl("@keyword", { fg = colors.orange, italic = true })
hl("@string", { fg = colors.gold })
hl("@comment", { fg = colors.comment, italic = true })
hl("@type", { fg = colors.cyan })
hl("@parameter", { fg = colors.violet })
hl("@property", { fg = colors.cyan })
hl("@punctuation", { fg = colors.fg_dim })
