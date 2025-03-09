return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Ensure LSP starts for all buffers
      vim.schedule(function()
        vim.cmd("LspStart")
      end)

      -- Configure pylsp with mypy
      opts.servers = opts.servers or {}
      opts.servers.pylsp = {
        settings = {
          pylsp = {
            plugins = {
              pycodestyle = { enabled = false },
              pylsp_mypy = {
                enabled = true,
                live_mode = true,
                strict = false,
                report_progress = true,
              },
            },
          },
        },
      }
    end,
  },
}
