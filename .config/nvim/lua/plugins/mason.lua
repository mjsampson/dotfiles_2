return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      -- Keep default options
      opts = opts or {}

      -- Ensure the default registry is first
      opts.registries = opts.registries or { "github:mason-org/mason-registry" }

      -- Add your custom registry
      table.insert(opts.registries, "file:~/.config/nvim/mason-registry")

      -- Set UI options to ensure modifiable buffers
      opts.ui = vim.tbl_deep_extend("force", opts.ui or {}, {
        check_outdated_packages_on_open = true,
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
        keymaps = {
          toggle_package_expand = "<CR>",
          install_package = "i",
          update_package = "u",
          check_package_version = "c",
          update_all_packages = "U",
          check_outdated_packages = "C",
          uninstall_package = "X",
          cancel_installation = "<C-c>",
          apply_language_filter = "<C-f>",
        },
      })

      return opts
    end,
  },
}
