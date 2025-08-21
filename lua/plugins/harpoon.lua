return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require 'harpoon'
    harpoon.setup {}

    vim.keymap.set('n', '<leader>a', function()
      harpoon:list():add()
    end, { desc = 'Add Harpoon Mark' })
    vim.keymap.set('n', '<C-e>', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = 'Toggle Harpoon Quick Menu' })
    vim.keymap.set('n', '<leader>m', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = 'Show Harpoon Marks' })

    vim.keymap.set('n', '<leader>1', function()
      harpoon:list():select(1)
    end, { desc = 'Select Harpoon Mark 1' })
    vim.keymap.set('n', '<leader>2', function()
      harpoon:list():select(2)
    end, { desc = 'Select Harpoon Mark 2' })
    vim.keymap.set('n', '<leader>3', function()
      harpoon:list():select(3)
    end, { desc = 'Select Harpoon Mark 3' })
    vim.keymap.set('n', '<leader>4', function()
      harpoon:list():select(4)
    end, { desc = 'Select Harpoon Mark 4' })
    vim.keymap.set('n', '<leader>c', function()
      harpoon:list():clear()
    end, { desc = 'Clear All Harpoon Marks' })

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set('n', '<leader>p', function()
      harpoon:list():prev()
    end, { desc = 'Select Previous Harpoon Mark' })
    vim.keymap.set('n', '<leader>n', function()
      harpoon:list():next()
    end, { desc = 'Select Next Harpoon Mark' })
  end,
}
