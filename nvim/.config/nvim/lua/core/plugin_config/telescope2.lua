local telescope_builtin = require 'telescope.builtin'
local telescope = require 'telescope'
local M = {}

telescope.setup {
  defaults = {
    prompt_position = 'top',
    layout_strategy = 'horizontal',
    sorting_strategy = 'ascending',
    use_less = false,
    file_ignore_patterns = {"%.git/"},
  }
}

M.find_files = function()
  telescope_builtin.find_files {
    find_command = { 'rg', '--files', '--hidden', '--glob', '!.git/**' },
    previewer = false
  }
end

M.find_config_files = function()
  local config_dir = vim.env.HOME .. '/.config/nvim'
  telescope_builtin.find_files {
    find_command = { 'rg', '--files', '--hidden', '--glob', '!.git/**', config_dir },
    previewer = false
  }
end

M.live_grep = function()
  telescope_builtin.live_grep {
    additional_args = function()
      return {'--hidden', '--glob', '!.git/**'}
    end
  }
end

M.file_browser = function()
  telescope_builtin.file_browser {
    hidden = true,
    respect_gitignore = false,
  }
end

M.buffers = function()
  telescope_builtin.buffers {
    previewer = false
  }
end

vim.keymap.set('n', '<c-p>', M.find_files, {})
vim.keymap.set('n', '<Space><Space>', telescope_builtin.oldfiles, {})
vim.keymap.set('n', '<Space>fg', M.live_grep, {})
vim.keymap.set('n', '<Space>fh', telescope_builtin.help_tags, {})

return M

