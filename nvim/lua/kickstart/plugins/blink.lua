return {
  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'InsertEnter',
    version = '1.*',

    dependencies = {
      -- Snippet Engine
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
          {
            'rafamadriz/friendly-snippets',
          },
        },

        config = function()
          local ls = require 'luasnip'

          -- Load friendly-snippets
          require('luasnip.loaders.from_vscode').lazy_load()

          -- Load your own VSCode-style snippets
          require('luasnip.loaders.from_vscode').load {
            paths = { vim.fn.stdpath 'config' .. '/snippets' },
          }

          -- Extend LaTeX snippets to Markdown
          ls.filetype_extend('markdown', { 'tex', 'latex' })

          -- Enable autosnippets
          ls.config.set_config {
            enable_autosnippets = true,
            store_selection_keys = '<C-f>',
          }

          -- Load your LuaSnip snippets
          require('luasnip.loaders.from_lua').lazy_load {
            paths = { vim.fn.stdpath 'config' .. '/luasnippets' },
          }
        end,
      },

      'folke/lazydev.nvim',
    },

    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'default',

        -- Manually open completion menu
        ['<C-l>'] = { 'show' },

        -- Accept completion/ghost text with Enter
        ['<CR>'] = { 'accept', 'fallback' },

        -- LuaSnip navigation
        ['<C-j>'] = { 'snippet_forward', 'fallback' },
        ['<C-k>'] = { 'snippet_backward', 'fallback' },
      },

      appearance = {
        nerd_font_variant = 'mono',
      },

      completion = {
        -- Do not automatically show completion suggestions
        menu = {
          auto_show = false,
        },

        documentation = {
          auto_show = false,
          auto_show_delay_ms = 500,
        },

        trigger = {
          show_in_snippet = false,
        },

        ghost_text = {
          -- Show inline completion suggestions
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
