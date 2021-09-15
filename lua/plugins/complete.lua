local cmp = require('cmp')
local luasnip = require("luasnip")

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s')
end

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local function config()
    cmp.setup {
        formatting = {
            format = function(entry, vim_item)
                local icons = require("lsp.kind").icons
                vim_item.kind = icons[vim_item.kind]
                vim_item.menu = ({
                    nvim_lsp = "(LSP)",
                    nvim_lua = "(Lua)",
                    path = "(Path)",
                    luasnip = "(Snippet)",
                    buffer = "(Buffer)"
                })[entry.source.name]
                vim_item.dup =
                    ({buffer = 1, path = 1, nvim_lsp = 0})[entry.source.name] or
                        0
                return vim_item
            end
        },
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end
        },
        documentation = {
            border = {"╭", "─", "╮", "│", "╯", "─", "╰", "│"},
            winhighlight = "NormalFloat:CmpDocumentation,FloatBorder:CmpDocumentationBorder"
        },
        sources = {
            {name = "nvim_lsp"}, {name = "path"}, {name = "luasnip"},
            {name = "nvim_lua"}, {name = "buffer"}
        },
        mapping = {
            ['<C-p>'] = cmp.mapping.select_prev_item(),
            ['<C-n>'] = cmp.mapping.select_next_item(),
            ["<C-d>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ['<Tab>'] = function(fallback)
                if vim.fn.pumvisible() == 1 then
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-n>',
                                                                   true, true,
                                                                   true), 'n')
                elseif luasnip.expand_or_jumpable() then
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes(
                                        '<Plug>luasnip-expand-or-jump', true,
                                        true, true), '')
                else
                    fallback()
                end
            end,
            ['<S-Tab>'] = function(fallback)
                if vim.fn.pumvisible() == 1 then
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-p>',
                                                                   true, true,
                                                                   true), 'n')
                elseif luasnip.jumpable(-1) then
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes(
                                        '<Plug>luasnip-jump-prev', true, true,
                                        true), '')
                else
                    fallback()
                end
            end,
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.close(),
            ["<CR>"] = cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Replace,
                select = true
            }
        }
    }
end

return {config = config}
