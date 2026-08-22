return {
  {
    'L3MON4D3/LuaSnip',
    version = '2.*',

    build = (function()
      if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
        return
      end
      return 'make install_jsregexp'
    end)(),

    dependencies = {
      'rafamadriz/friendly-snippets',
    },

    config = function()
      local ls = require 'luasnip'

      ls.config.set_config {
        enable_autosnippets = true,
        store_selection_keys = '<C-f>',
      }

      require('luasnip.loaders.from_vscode').lazy_load()

      require('luasnip.loaders.from_vscode').lazy_load {
        paths = {
          vim.fn.stdpath 'config' .. '/snippets',
        },
      }

      require('luasnip.loaders.from_lua').lazy_load {
        paths = {
          vim.fn.stdpath 'config' .. '/luasnippets',
        },
      }

      ls.filetype_extend('markdown', { 'tex', 'latex' })
    end,
  },

  {
    'saghen/blink.cmp',
    event = 'InsertEnter',
    version = '1.*',

    dependencies = {
      'L3MON4D3/LuaSnip',
      'folke/lazydev.nvim',
    },

    opts = {
      keymap = {
        preset = 'default',

        ['<C-l>'] = { 'show' },
        ['<CR>'] = { 'accept', 'fallback' },

        ['<C-j>'] = { 'snippet_forward', 'fallback' },
        ['<C-k>'] = { 'snippet_backward', 'fallback' },
      },

      appearance = {
        nerd_font_variant = 'mono',
      },

      completion = {
        menu = {
          auto_show = false,
        },

        documentation = {
          auto_show = false,
          auto_show_delay_ms = 500,
        },

        ghost_text = {
          enabled = true,
        },
      },

      sources = {
        default = {
          'lsp',
          'path',
          'snippets',
          'buffer',
          'lazydev',
        },

        providers = {
          lazydev = {
            module = 'lazydev.integrations.blink',
            score_offset = 100,
          },
        },
      },

      snippets = {
        preset = 'luasnip',
      },

      fuzzy = {
        implementation = 'lua',
      },

      signature = {
        enabled = true,
      },
    },
  },
}
