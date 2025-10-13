local config = {
end


ts('@comment', { fg = p.comment, italic = config.italics })
ts('@punctuation', { fg = p.fg })
ts('@operator', { fg = p.cyan })
ts('@string', { fg = p.mint })
ts('@character', { fg = p.teal })
ts('@number', { fg = p.gold })
ts('@boolean', { fg = p.rose })
ts('@constant', { fg = p.yellow })
ts('@constant.builtin',{ fg = p.gold, italic = config.italics })
ts('@variable', { fg = p.fg })
ts('@variable.builtin',{ fg = p.pink, italic = config.italics })
ts('@field', { fg = p.pink })
ts('@property', { fg = p.pink })
ts('@parameter', { fg = p.cyan })
ts('@function', { fg = p.lilac, bold = true })
ts('@function.builtin',{ fg = p.violet, italic = config.italics })
ts('@constructor', { fg = p.blue })
ts('@type', { fg = p.green })
ts('@type.builtin', { fg = p.green, italic = config.italics })
ts('@keyword', { fg = p.purple, italic = config.italics })
ts('@keyword.return', { fg = p.red, italic = config.italics })
ts('@conditional', { fg = p.violet })
ts('@repeat', { fg = p.violet })
ts('@tag', { fg = p.blue })
ts('@attribute', { fg = p.yellow })
ts('@markup.link', { fg = p.cyan, underline = true })
ts('@markup.heading', { fg = p.lilac, bold = true })


-- Plugins
hi('TelescopeNormal', { fg = p.fg, bg = p.bg_alt })
hi('TelescopeBorder', { fg = p.gutter, bg = p.bg_alt })
hi('TelescopePromptNormal', { fg = p.fg, bg = p.ui })
hi('TelescopePromptBorder', { fg = p.gutter, bg = p.ui })
hi('TelescopeSelection', { fg = p.bg, bg = p.pink, bold = true })


hi('NvimTreeNormal', { fg = p.fg, bg = p.bg_alt })
hi('NvimTreeFolderIcon', { fg = p.violet })
hi('NvimTreeFolderName', { fg = p.violet })
hi('NvimTreeRootFolder', { fg = p.lilac, bold = true })
hi('GitSignsAdd', { fg = p.green })
hi('GitSignsChange', { fg = p.gold })
hi('GitSignsDelete', { fg = p.red })


-- Terminal palette
vim.g.terminal_color_0 = p.bg
vim.g.terminal_color_1 = p.red
vim.g.terminal_color_2 = p.green
vim.g.terminal_color_3 = p.gold
vim.g.terminal_color_4 = p.blue
vim.g.terminal_color_5 = p.violet
vim.g.terminal_color_6 = p.teal
vim.g.terminal_color_7 = p.fg
vim.g.terminal_color_8 = p.gutter
vim.g.terminal_color_9 = p.red
vim.g.terminal_color_10 = p.green
vim.g.terminal_color_11 = p.yellow
vim.g.terminal_color_12 = p.blue
vim.g.terminal_color_13 = p.purple
vim.g.terminal_color_14 = p.cyan
vim.g.terminal_color_15 = p.fg


-- Diff
hi('DiffAdd', { bg = '#102319', fg = p.green })
hi('DiffChange', { bg = '#2a1f0f', fg = p.gold })
hi('DiffDelete', { bg = '#2a1418', fg = p.red })
hi('DiffText', { bg = '#2a2410', fg = p.yellow, bold = true })
end


local M = {}
M.setup = setup
M.load = apply


if vim.g.colors_name ~= 'fairyfloss-muted' then
if type(vim.g.fairyfloss_muted) == 'table' then setup(vim.g.fairyfloss_muted) end
apply()
end


return M
