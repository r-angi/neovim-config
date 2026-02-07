-- Collection of various small independent plugins/modules
return {
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup {
        n_lines = 500,
        custom_textobjects = {
          -- Matching pairs textobject (works with yim, dim, cim, etc.)
          m = {
            { "%b()", "%b[]", "%b{}" },
            "^.().*().$",
          },
          -- Jupyter cell textobject (ih = inner cell, ah = around cell including marker)
          h = function(...)
            local ok, nn = pcall(require, 'notebook-navigator')
            if ok then return nn.miniai_spec(...) end
          end,
        }
      }

      -- Highlight # %% cell markers in Python files
      local hipatterns = require('mini.hipatterns')
      hipatterns.setup({
        highlighters = {
          cell_marker = {
            pattern = '^# %%%%.*',
            group = 'MiniHipatternsNote',
          },
        },
      })

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- Add custom diagnostics section to show errors/warnings
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_diagnostics = function()
        local diagnostics = vim.diagnostic.get(0) -- Get diagnostics for current buffer
        local errors = 0
        local warnings = 0
        local hints = 0
        local info = 0

        for _, diagnostic in ipairs(diagnostics) do
          if diagnostic.severity == vim.diagnostic.severity.ERROR then
            errors = errors + 1
          elseif diagnostic.severity == vim.diagnostic.severity.WARN then
            warnings = warnings + 1
          elseif diagnostic.severity == vim.diagnostic.severity.HINT then
            hints = hints + 1
          elseif diagnostic.severity == vim.diagnostic.severity.INFO then
            info = info + 1
          end
        end

        local parts = {}
        if errors > 0 then
          table.insert(parts, string.format('%%#DiagnosticError#E:%d%%*', errors))
        end
        if warnings > 0 then
          table.insert(parts, string.format('%%#DiagnosticWarn#W:%d%%*', warnings))
        end
        if hints > 0 then
          table.insert(parts, string.format('%%#DiagnosticHint#H:%d%%*', hints))
        end
        if info > 0 then
          table.insert(parts, string.format('%%#DiagnosticInfo#I:%d%%*', info))
        end

        if #parts > 0 then
          return table.concat(parts, ' ')
        else
          return ''
        end
      end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  }