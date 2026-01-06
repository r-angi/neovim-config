--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Map jk to Escape for easier access from insert mode
vim.keymap.set('i', 'jk', '<Esc>', { desc = 'Alternative Escape key' })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>yd', function()
  local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })
  if #diagnostics > 0 then
    vim.fn.setreg('+', diagnostics[1].message)
    print('Diagnostic copied to clipboard')
  end
end, { desc = '[Y]ank [D]iagnostic to clipboard' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Motion remapping: Replace hard-to-type % with easier m
-- Jump to matching pair (preserves m for marks via mm)
vim.keymap.set('n', 'mm', '%', { desc = 'Jump to [M]atching pair' })

-- Select until matching pair in visual mode
vim.keymap.set('x', 'm', '%', { desc = 'Select until [M]atching pair' })

-- Use with operators (dm, cm, ym, etc.)
vim.keymap.set('o', 'm', '%', { desc = 'Operate until [M]atching pair' })

-- Visual select to end of entire block
vim.keymap.set('n', 'M', 'v%', { desc = 'Visual select [M]atching block' })

-- Window management: vertical split with auto-focus
vim.keymap.set('n', '<leader>|', '<C-w>v', { desc = 'Split window vertically' })

-- Yank (copy) filename keymaps
vim.keymap.set('n', '<leader>yf', function()
  local path = vim.fn.expand('%')
  vim.fn.setreg('+', path)
  print('Copied relative path: ' .. path)
end, { desc = '[Y]ank relative [F]ilename' })

vim.keymap.set('n', '<leader>yF', function()
  local path = vim.fn.expand('%:p')
  vim.fn.setreg('+', path)
  print('Copied absolute path: ' .. path)
end, { desc = '[Y]ank absolute path ([F]ull)' })

vim.keymap.set('n', '<leader>yn', function()
  local name = vim.fn.expand('%:t')
  vim.fn.setreg('+', name)
  print('Copied filename: ' .. name)
end, { desc = '[Y]ank file[N]ame only' })
