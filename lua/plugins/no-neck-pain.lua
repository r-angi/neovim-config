return {
  "shortcuts/no-neck-pain.nvim",
  version = "*",
  config = function()
    require("no-neck-pain").setup({
      width = 120,
      autocmds = {
        enableOnVimEnter = false,
        reloadOnColorSchemeChange = true,
      },
      buffers = {
        scratchPad = {
          enabled = false,
        },
        bo = {
          filetype = "no-neck-pain",
        },
      },
      integrations = {
        NeoTree = {
          position = "left",
          reopen = true,
        },
        oil = {
          position = "left",
          reopen = true,
        },
        NvimTree = {
          position = "left",
          reopen = true,
        },
      },
    })
  end,
  keys = {
    { "<leader>tn", "<cmd>NoNeckPain<cr>", desc = "Toggle No Neck Pain" },
  },
}