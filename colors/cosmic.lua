-- ~/.config/nvim/colors/cosmic.lua

vim.cmd('hi clear')
if vim.fn.exists('syntax_on') then
	vim.cmd('syntax reset')
end

vim.g.colors_name = 'cosmic'

local is_dark = vim.o.background == 'dark'

-- Palettes
local colors = {}

if is_dark then
	-- BLACK HOLE (Dark Mode)
	colors = {
		bg        = '#0B0A1A', -- Deep void black/blue
		fg        = '#E0E0FF', -- Starlight white
		bg_alt    = '#16152B', -- Slightly lighter void for UI elements
		comment   = '#6A6A8A', -- Dim nebula dust
		keyword   = '#FF00FF', -- Neon magenta
		func      = '#00FFFF', -- Neon cyan
		string    = '#00FF99', -- Neon mint
		type      = '#B055FF', -- Neon purple
		constant  = '#FF007F', -- Neon pink
		warning   = '#FFD700', -- Yellow dwarf
		error     = '#FF3333', -- Red giant
		line_nr   = '#3A3A5A',
		cursor_bg = '#2A2A4A',
	}
else
	-- SUPER NOVA (Light Mode)
	colors = {
		bg        = '#FAFAFF', -- Blinding starlight white
		fg        = '#1A1A3A', -- Dense matter dark blue
		bg_alt    = '#EAEAF5', -- Soft plasma shadow
		comment   = '#8080A0', -- Faded stardust
		keyword   = '#FF007F', -- Bright neon pink
		func      = '#0066FF', -- Intense neon blue
		string    = '#FF6600', -- Solar flare orange
		type      = '#6600FF', -- Deep ultraviolet
		constant  = '#D900FF', -- Intense magenta
		warning   = '#E69900', -- Corona yellow
		error     = '#D90000', -- Heat death red
		line_nr   = '#B0B0D0',
		cursor_bg = '#D0D0E8',
	}
end

-- Highlight Groups Definition
local highlights = {
	-- Base UI
	Normal          = { fg = colors.fg, bg = colors.bg },
	NormalFloat     = { fg = colors.fg, bg = colors.bg_alt },
	ColorColumn     = { bg = colors.bg_alt },
	CursorLine      = { bg = colors.cursor_bg },
	CursorLineNr    = { fg = colors.keyword, bold = true },
	LineNr          = { fg = colors.line_nr },
	VertSplit       = { fg = colors.line_nr },
	SignColumn      = { bg = colors.bg },
	Visual          = { bg = colors.bg_alt, bold = true },
	Pmenu           = { fg = colors.fg, bg = colors.bg_alt },
	PmenuSel        = { fg = colors.bg, bg = colors.func },

	-- Syntax
	Comment         = { fg = colors.comment, italic = true },
	String          = { fg = colors.string },
	Number          = { fg = colors.constant },
	Boolean         = { fg = colors.constant, bold = true },
	Keyword         = { fg = colors.keyword, italic = true },
	Function        = { fg = colors.func, bold = true },
	Type            = { fg = colors.type },
	Statement       = { fg = colors.keyword },
	Identifier      = { fg = colors.fg },
	Constant        = { fg = colors.constant },
	Operator        = { fg = colors.func },
	PreProc         = { fg = colors.keyword },
	Special         = { fg = colors.warning },

	-- Diagnostics
	DiagnosticError = { fg = colors.error },
	DiagnosticWarn  = { fg = colors.warning },
	DiagnosticInfo  = { fg = colors.func },
	DiagnosticHint  = { fg = colors.string },

	-- Git Signs
	GitSignsAdd     = { fg = colors.string },
	GitSignsChange  = { fg = colors.warning },
	GitSignsDelete  = { fg = colors.error },
}

-- Apply Highlights
for group, opts in pairs(highlights) do
	vim.api.nvim_set_hl(0, group, opts)
end
