---@diagnostic disable: lowercase-global
---@diagnostic disable: need-check-nil

----------
-- TODO --
----------

----------------
-- File types --
----------------

-- 2-space indent for some file types
vim.api.nvim_create_autocmd("FileType", {
    pattern = "yaml,toml,markdown,html,css",
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.shiftwidth = 2
    end
})

-- Tree Sitter
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "lua", "python", "rust", "sql", "kdl", "bash", "zig", "dockerfile", "html" },
    callback = function()
        vim.treesitter.start()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})

-- Disable comment continuation
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function()
        vim.opt.formatoptions = "jql"
    end,
})

-----------------------
-- Markdown wrapping --
-----------------------

do
  local group = vim.api.nvim_create_augroup(
    "UserMarkdownUI",
    { clear = true }
  )

  local restore_columns = nil

  local function is_markdown()
    return vim.bo.filetype == "markdown"
  end

  local function clamp_markdown_columns()
    if not is_markdown() then
      return
    end

    -- Get total width of the instance (not columns)
    local width = vim.api.nvim_list_uis()[1].width

    if width > 120 then
      vim.o.columns = 100
    elseif width > 80 then
      vim.o.columns = 80
    else
      vim.o.columns = 70
    end
  end

  local function set_markdown_wrap()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true

    -- Soft wrap only; do not insert real newlines.
    vim.opt_local.textwidth = 0
    vim.opt_local.wrapmargin = 0
  end

  local function disable_scrollbar()
    -- Call ScrollbarHide command (quiet) with delay
    vim.defer_fn(function()
      if vim.fn.exists(":ScrollbarHide") == 2 then
        vim.cmd("silent! ScrollbarHide")
      end
    end, 100)
  end

  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "markdown",
    callback = function()
      set_markdown_wrap()
      disable_scrollbar()

      clamp_markdown_columns()
    end,
  })

  vim.api.nvim_create_autocmd({
    "BufEnter",
    "WinEnter",
    "WinResized",
  }, {
    group = group,
    callback = clamp_markdown_columns,
  })
end

-----------------------
-- Highlight on Yank --
-----------------------

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({
      higroup = "LocalHighlight",
      timeout = 200,
    })
  end,
})

-------------
-- Plugins --
-------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

vim.cmd.colorscheme("nuitbleue")
vim.opt.termguicolors = true

require("lazy").setup({
    local_spec = false,
    install = { missing = false },

    spec = {
        -- Surround
        {
            "kylechui/nvim-surround",
            version = "*", -- Use for stability; omit to use `main` branch for the latest features
            event = "VeryLazy",
            config = function()
                vim.g.nvim_surround_no_normal_mappings = true
                require("nvim-surround").setup({})

                -- HACK: restore an "S" overwritten by plugin. Fuck nvim-surround
                vim.keymap.set({ "n", "v" }, "S", "5j", {})

                -- HACK: remove "ds" keymap since it's breaking WASD movements
                vim.keymap.del({ "n" }, "ds")
            end
        },

        -- File Manager
        {
            "stevearc/oil.nvim",
            event = "VeryLazy",
            opts = {
                columns = { "icon", "permissions", "size" },

                delete_to_trash = true,
                skip_confirm_for_simple_edits = true,
                watch_for_changes = true,
                view_options = {
                    show_hidden = true,
                    show_column_number = false,
                },
                float = {
                    padding = 3,
                    max_width = 80,
                    max_height = 30,
                    ---@diagnostic disable-next-line: unused-local
                    get_win_title = function(winid)
                        return ""
                    end,
                },
                keymaps = {
                    ["?"] = { "actions.show_help", mode = "n" },
                    ["<bs>"] = { "actions.parent", mode = "n" },
                    ["<c-cr>"] = { "actions.preview", mode = "n" },
                },
            },
        },

        -- Highlight word under cursor
        {
            "tzachar/local-highlight.nvim",
            event = "VeryLazy",
            config = function()
                require("local-highlight").setup({
                    min_match_len = 2,
                    max_match_len = 30,
                    cw_hlgroup = "LocalHighlight",
                    highlight_single_match = true,
                    debounce_timeout = 50,
                    animate = {
                        enabled = false,
                    },
                })

                vim.cmd("LocalHighlightOn")
            end,
        },

        -- Copilot
        {
            "zbirenbaum/copilot.lua",
            event = "VeryLazy",
            config = function()
                local function is_buffer_share_safe(bufnr, bufname)
                    -- Unlisted buffers
                    if not vim.bo[bufnr].buflisted then
                        return false
                    end

                    -- Unnamed buffers
                    if vim.bo[bufnr].buftype ~= "" then
                        return false
                    end

                    local path = vim.fs.normalize(bufname)
                    local parent = vim.fs.dirname(path)
                    local basename = vim.fs.basename(path)

                    -- Env files
                    if vim.startswith(basename, ".env") then
                        return false
                    end

                    -- Password store files
                    local password_store_path = vim.fs.normalize(vim.fs.joinpath(vim.env.HOME, ".password-store"))

                    if vim.startswith(path, password_store_path) then
                        return false
                    end

                    if vim.fs.basename(parent):match("^pass%.[^/]+$") then
                        return false
                    end

                    return true
                end

                require("copilot").setup({
                    panel = {
                        enabled = false,
                    },
                    suggestion = {
                        auto_trigger = true,
                        debounce = 25,
                    },
                    should_attach = is_buffer_share_safe,
                    filetypes = {
                        markdown = true,
                        yaml = true,
                        gitcommit = true,
                    },
                })
            end,
        },

        -- Better notifications
        {
            "rcarriga/nvim-notify",
            event = "VeryLazy",
            opts = {
                timeout = 2000,
                stages = "static",
                render = "minimal",
            },
        },

        -- Better UI
        {
            "folke/noice.nvim",
            event = "VeryLazy",
            config = function()
                require("noice").setup({
                    routes = {
                        -- Remove search counter
                        {
                            filter = { event = "msg_show", kind = "search_count" },
                            opts = { skip = true },
                        },
                        -- Remove save file message
                        {
                            filter = { find = " written" },
                            opts = { skip = true },
                        },
                        -- Remove undo/redo messages
                        {
                            filter = { find = " before #" },
                            opts = { skip = true },
                        },
                        {
                            filter = { find = " after #" },
                            opts = { skip = true },
                        },
                        -- Remove paste messages
                        {
                            filter = { find = " more lines" },
                            opts = { skip = true },
                        },
                        -- Remove deprecated messages
                        {
                            filter = { find = " deprecate" },
                            opts = { skip = true },
                        },
                        -- Remove deprecated messages about diagnostic signs
                        {
                            filter = { find = "Defining diagnostic signs " },
                            opts = { skip = true },
                        },
                        -- Remove some non-critical LSP messages (?)
                        {
                            filter = { find = "ServerNotInitialized" },
                            opts = { skip = true },
                        },
                        -- LSP hover messages
                        {
                            filter = { find = "No information available" },
                            opts = { skip = true },
                        },
                        -- LSP shit
                        {
                            filter = { find = "method textDocument/signatureHelp is not supported" },
                            opts = { skip = true },
                        },
                    },
                    window = {
                        border = "rounded",
                    },
                    messages = {
                        enabled = true,
                    },
                    lsp = {
                        progress = {
                            enabled = false,
                        },
                        -- Auto-open signature help while typing inside a call
                        signature = {
                            enabled = true,
                            auto_open = {
                                enabled = true,
                                trigger = true,
                            },
                        },
                    },
                    presets = {
                        bottom_search = true,
                        command_palette = true,
                        long_message_to_split = true,
                        inc_rename = false,
                        lsp_doc_border = true,
                    },
                })
            end,
        },

        -- Color column as a characters
        {
            "lukas-reineke/virt-column.nvim",
            opts = {},
            config = function()
                require("virt-column").setup({
                    char = "¦",
                    virtcolumn = "80,120",
                })
            end,
        },

        -- Move diagnostics to top
        {
            "dgagn/diagflow.nvim",
            version = false,
            event = "VeryLazy",
            opts = {
                padding_right = 2,
                gap_size = 2,
                -- FIXME: wait until author fixes https://github.com/dgagn/diagflow.nvim/issues/54
                show_borders = true,
                border_chars = {
                    top_left = " ",
                    top_right = " ",
                    bottom_left = " ",
                    bottom_right = " ",
                    horizontal = " ",
                    vertical = " "
                },
                scope = "line",
                format = function(diagnostic)
                    -- No errors in insert mode
                    if vim.api.nvim_get_mode().mode == "i" then
                        return ""
                    end

                    local current_line = vim.fn.line(".")
                    local top_line = vim.fn.line("w0")
                    local relative_line = current_line - top_line

                    -- No diagnostics then current line is too high in visible area
                    if relative_line < 8 then
                        return ""
                    end

                    -- NOTE: NBSP from pyright breaking the border
                    -- NOTE: quotes from harper too
                    return diagnostic.message:gsub(" ", ".")
                        :gsub("“", "\"")
                        :gsub("”", "\"")
                end,
            }
        },

        -- Indentation guides
        {
            "lukas-reineke/indent-blankline.nvim",
            main = "ibl",
            opts = {},
            config = function()
                require("ibl").setup({
                    indent = { char = "¦" },
                    scope = {
                        enabled = true,
                        show_start = false,
                        show_end = false,
                    },
                })
            end,
        },

        -- Completion
        {
            "hrsh7th/nvim-cmp",
            event = "VeryLazy",
            dependencies = {
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-path",
                "hrsh7th/cmp-cmdline",
            },
            config = function()
                local cmp = require("cmp")

                local cmp_kinds = {
                    Text = '󰊄 ',
                    Method = '󰊕 ',
                    Function = '󰊕 ',
                    Constructor = '󰊕 ',
                    Field = '󰬟 ',
                    Variable = '󰬟 ',
                    Class = ' ',
                    Interface = '󰬐 ',
                    Module = '󰰐 ',
                    Property = '󰬟  ',
                    Unit = ' ',
                    Value = ' ',
                    Enum = ' ',
                    Keyword = ' ',
                    Snippet = ' ',
                    Color = ' ',
                    File = ' ',
                    Reference = ' ',
                    Folder = ' ',
                    EnumMember = ' ',
                    Constant = ' ',
                    Struct = ' ',
                    Event = ' ',
                    Operator = ' ',
                    TypeParameter = ' ',
                }

                cmp.setup({
                    preselect = false,
                    window = {
                        completion = cmp.config.window.bordered {
                            border = 'single',
                            winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:Visual,Search:None',
                        },
                        documentation = cmp.config.window.bordered {
                            border = 'single',
                            winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:Visual,Search:None',
                        },
                    },
                    mapping = {
                        ["<down>"] = cmp.mapping.select_next_item(),
                        ["<up>"] = cmp.mapping.select_prev_item(),
                        ["<c-e>"] = cmp.mapping.close(),
                        ["<c-cr>"] = cmp.mapping.confirm(),
                        -- NOTE: handled by tab_complete function
                        -- ["<tab>"] = cmp.mapping.select_next_item(),
                        ["<s-tab>"] = cmp.mapping.select_prev_item(),
                    },
                    sources = {
                        { name = "nvim_lsp" },
                        { name = "buffer" },
                        { name = "path" },
                    },
                    formatting = {
                        fields = { 'kind', 'abbr' },
                        format = function(_, vim_item)
                            vim_item.kind = cmp_kinds[vim_item.kind] or ''
                            vim_item.menu = ''
                            return vim_item
                        end,
                    },
                })
            end,
        },

        -- Multiple cursors
        --   Alternatives:
        --   - terryma/vim-multiple-cursors -- kinda works with custom mappings, but deprecated and buggy
        --   - mg979/vim-visual-multi -- doesn't work with custom mappings
        --   - jake-stewart/multicursor.nvim -- works, but is not interactive
        --   - brenton-leighton/multiple-cursors.nvim -- doesn't work with custom mappings
        {
            "jake-stewart/multicursor.nvim",
            event = "VeryLazy",
            branch = "1.0",
            config = function()
                local mc = require("multicursor-nvim")

                mc.setup({
                    signs = { "┆", "▍", "┃", "↑", "↓", "⇡", "⇣" },
                })

                vim.keymap.set({ "n", "v" }, "C", function() mc.lineAddCursor(1) end)
                vim.keymap.set({ "n" }, "<c-d>", function()
                    vim.cmd('normal! viw')
                end)
                vim.keymap.set({ "v" }, "<c-d>", function() mc.matchAddCursor(1) end)
                vim.keymap.set({ "v" }, "l", function() mc.splitCursors("$") end)
                vim.keymap.set({ "v" }, ",", function() mc.splitCursors(",") end)
                vim.keymap.set({ "v" }, "L", function() mc.splitCursors() end)
                vim.keymap.set({ "v" }, "m", function() mc.matchCursors() end)

                vim.keymap.set("n", "<esc>", function()
                    if not mc.cursorsEnabled() then
                        mc.enableCursors()
                    elseif mc.hasCursors() then
                        mc.clearCursors()
                    else
                        vim.cmd("nohlsearch")

                        -- Close all floating windows except zen-mode
                        -- vim.cmd("fclose")
                        for _, win in ipairs(vim.api.nvim_list_wins()) do
                            local conf = vim.api.nvim_win_get_config(win)
                            if conf.relative ~= "" and conf.zindex > 40 then
                                vim.api.nvim_win_close(win, true)
                            end
                        end
                    end
                end)
            end,
        },

        -- LSP
        {
            "neovim/nvim-lspconfig",
            version = "*",
            config = function()
                local border = {
                    { "┌", "FloatBorder" },
                    { "─", "FloatBorder" },
                    { "┐", "FloatBorder" },
                    { "│", "FloatBorder" },
                    { "┘", "FloatBorder" },
                    { "─", "FloatBorder" },
                    { "└", "FloatBorder" },
                    { "│", "FloatBorder" },
                }

                local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
                function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
                    opts = opts or {}
                    opts.border = opts.border or border
                    return orig_util_open_floating_preview(contents, syntax, opts, ...)
                end

                -- LUA
                vim.lsp.config("lua_ls", {
                    settings = {
                        Lua = {
                            diagnostics = {
                                -- For init.lua
                                globals = {
                                    'vim',
                                    'require'
                                },
                            },
                            telemetry = { enable = false },
                        },
                    },
                })
                vim.lsp.enable("lua_ls")

                -- Python
                -- Autocomplete, Imports, Type checking
                vim.lsp.config("pyright", {
                    settings = {
                        python = {
                            analysis = {
                                typeCheckingMode = "strict",

                                diagnosticSeverityOverrides = {
                                    -- Fix diagnostics level
                                    reportUnknownParameterType = "warning",
                                    reportMissingParameterType = "warning",
                                    reportUnknownArgumentType = "warning",
                                    reportUnknownLambdaType = "warning",
                                    reportUnknownMemberType = "warning",
                                    reportUnusedFunction = "warning",
                                    reportUnusedVariable = "warning",
                                    reportUntypedFunctionDecorator = "warning",
                                    reportDeprecated = "warning",

                                    -- Enable extra diagnostics
                                    reportUnusedCallResult = "warning",
                                    reportUninitializedInstanceVariable = "warning",

                                    -- Gradual typing in new projects
                                    reportMissingImports = false,
                                    reportMissingTypeStubs = false,
                                    reportUnknownVariableType = false,

                                    -- Covered by ruff
                                    reportUnusedImport = false,
                                },
                            },
                        },
                    },
                })
                vim.lsp.enable("pyright")

                -- Linting / formatting
                vim.lsp.config("ruff", {
                    settings = {
                        ruff = {
                            -- Enable all rules, since we can filter them with `# noqa` comments
                            enabled = true,
                            -- Don't show warnings about missing type hints, since it's not critical and usually requires manual work to fix
                            ignore = { "ANN" },
                        },
                    },
                })
                vim.lsp.enable("ruff")

                -- YAML
                vim.lsp.config("yamlls", {
                    settings = {
                        yaml = {
                            schemas = {
                                ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
                                ["https://json.schemastore.org/prettierrc.json"] = "/.prettierrc*",
                                ["https://json.schemastore.org/stylelintrc.json"] = "/.stylelintrc*",
                                -- TODO: add .gitlab-ci.yml
                                -- TODO: add docker-compose
                            },
                        },
                    },
                })
                vim.lsp.enable("yamlls")

                -- TOML
                vim.lsp.config("taplo", {
                    settings = {
                        taplo = {
                        },
                    },
                })
                vim.lsp.enable("taplo")

                -- HTML
                vim.lsp.config("emmet_language_server", {
                    filetypes = { "python", "html", "markdown" },
                    preferences = {
                        caniuse = {
                            enabled = false,
                        },
                    },
                })
                vim.lsp.enable("emmet_language_server")

                -- lsp.html.setup({}) -- vscode shit, doesn't provide autocomplete anyway
                vim.lsp.config("superhtml", {
                    settings = {
                        superhtml = {},
                    },
                })
                vim.lsp.enable("superhtml")

                -- Typst
                vim.lsp.config("tinymist", {
                    settings = {
                        formatterMode = "typstyle",
                        exportPdf = "onType",
                    },
                })
                vim.lsp.enable("tinymist")

                -- Zig
                vim.lsp.config("zls", {
                    settings = {
                        zls = {
                            enable_autofix = true,
                            enable_inlay_hints = false,
                            enable_argument_placeholders = false,
                            semantic_tokens = "partial",

                            enable_build_on_save = true,
                            build_on_save_args = { "check" },

                            -- Mostly annoying
                            -- warn_style = true,
                        },
                    },
                })
                vim.lsp.enable("zls")

                -- Rust
                vim.lsp.config("rust_analyzer", {
                    settings = {
                        ["rust-analyzer"] = {
                            cachePriming = {
                                enable = false,
                            },
                            cargo = {
                                -- Use separate target directory for rust-analyzer to remove interferences with cargo
                                targetDir = true,
                            },
                            check = {
                                command = "clippy",
                            },
                            procMacro = {
                                enable = true,
                            },
                            completion = {
                                limit = 1024,
                                callable = {
                                    snippets = "none",
                                },
                                postfix = {
                                    enable = false,
                                },
                                hideDeprecated = true,
                            },
                            imports = {
                                preferNoStd = true,
                            },
                            lens = {
                                enable = false,
                            },
                            diagnostics = {
                                experimental = {
                                    enabled = true,
                                },
                                styleLints = {
                                    enable = true,
                                },
                            },
                            rustfmt = {
                                extraArgs = {
                                    "--config=empty_item_single_line=false",
                                    "--config=wrap_comments=true",
                                    "--config=condense_wildcard_suffixes=true",
                                    "--config=enum_discrim_align_threshold=10",
                                    "--config=format_code_in_doc_comments=true",
                                    "--config=hex_literal_case=Upper",
                                    "--config=max_width=120",
                                    "--config=reorder_impl_items=true",
                                    "--config=group_imports=StdExternalCrate",
                                    "--config=use_field_init_shorthand=true",
                                },
                            },
                        },
                    },
                })
                vim.lsp.enable("rust_analyzer")

                -- JavaScript
                vim.lsp.config("ts_ls", {
                    settings = {
                        ts_ls = {
                        },
                    },
                })
                vim.lsp.enable("ts_ls")

                -- Codebook (spell checking)
                -- NOTE: this is a custom autocmd to wait until codebook attach
                --       and change it's diagnostic sign to custom one.
                --       Needed, because namespace is created dynamically
                vim.api.nvim_create_autocmd("LspAttach", {
                    group = vim.api.nvim_create_augroup("CodebookDiagnostics", { clear = true }),
                    callback = function(event)
                        local client_id = event.data and event.data.client_id
                        local client = client_id and vim.lsp.get_client_by_id(client_id)
                        if not client or client.name ~= "codebook" then
                            return
                        end

                        local ok, codebook_ns = pcall(vim.lsp.diagnostic.get_namespace, client_id)
                        if not ok or not codebook_ns then
                            local reason = ok and "no namespace was returned" or tostring(codebook_ns)
                            vim.notify(
                                ("Unable to configure Codebook diagnostics for client %d: %s")
                                    :format(client_id, reason),
                                vim.log.levels.WARN
                            )
                            return
                        end

                        vim.diagnostic.config({
                            underline = true,
                            signs = {
                                text = {
                                    [vim.diagnostic.severity.HINT] = "󰓆",
                                },
                            },
                        }, codebook_ns)
                    end,
                })

                vim.lsp.config("codebook", {
                    init_options = {
                        diagnosticSeverity = "hint",
                    },
                })
                vim.lsp.enable("codebook")
            end,
        },

        -- Formatting for html/css; falls back to LSP formatting elsewhere
        {
            "stevearc/conform.nvim",
            event = "VeryLazy",
            opts = {
                formatters_by_ft = {
                    html = { "prettierd" },
                    css = { "prettierd" },
                },
                default_format_opts = {
                    lsp_format = "fallback",
                },
            },
        },

        -- Treesitter
        {
            "nvim-treesitter/nvim-treesitter",
            branch = "main",
            event = "VeryLazy",
            build = ":TSUpdate",
            config = function()
                require("nvim-treesitter").install({
                    -- Programming
                    "python",
                    "rust",
                    "zig",
                    "javascript",
                    "typescript",

                    -- Markup
                    "html",
                    "markdown",
                    "css",

                    -- Scripting
                    "bash",
                    "lua",
                    "sql",

                    -- Configuration
                    "toml",
                    "yaml",
                    "json",
                    "ini",
                    "kdl",

                    -- Other
                    "git_config",
                    "dockerfile",
                })
            end,
        },

        -- Treesitter text objects
        {
            "nvim-treesitter/nvim-treesitter-textobjects",
            branch = "main",
            event = "VeryLazy",
            keys = {
                {
                    "F",
                    function()
                        require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
                    end,
                    mode = "n",
                },
            },
        },

        -- Git gutter
        {
            "lewis6991/gitsigns.nvim",
            event = "VeryLazy",
            config = function()
                local signs = {
                    add          = { text = '│' },
                    change       = { text = '│' },
                    delete       = { text = '▁' },
                    topdelete    = { text = '▔' },
                    changedelete = { text = '⋯' },
                    untracked    = { text = '┆' },
                }

                local gitsigns = require("gitsigns")

                gitsigns.setup({
                    signs = signs,
                    signs_staged = signs,
                    numhl = false,
                })

                vim.keymap.set("n", "gp", gitsigns.preview_hunk, {})
                vim.keymap.set("n", "ga", gitsigns.stage_hunk, {})
            end,
        },

        -- Scrollbar
        {
            "petertriho/nvim-scrollbar",
            event = "VeryLazy",
            opts = {
                handle = {
                    -- highlight = "Visual",
                },
                handlers = {
                    cursor = false,
                    diagnostic = true,
                    gitsigns = true,
                    handle = true,
                },
            },
        },

        -- File picker / Live grep
        {
            "nvim-telescope/telescope.nvim",
            event = "VeryLazy",
            dependencies = { 'nvim-lua/plenary.nvim' },
            config = function()
                local actions = require("telescope.actions")
                local actions_layout = require("telescope.actions.layout")
                local themes = require("telescope.themes")

                require("telescope").setup({
                    extensions = {
                        ["ui-select"] = {
                            themes.get_dropdown({
                                prompt_title = "",
                                layout_config = {
                                    vertical = {
                                        width = 0.3,
                                        height = 0.5,
                                    },
                                },
                            }),
                        },
                    },
                    defaults = {
                        -- Close pickers on first Escape instead of going to normal mode
                        mappings = {
                            i = {
                                ["<esc>"] = actions.close,
                                ["<c-p>"] = actions_layout.toggle_preview,
                                ["<c-down>"] = actions.cycle_history_next,
                                ["<c-up>"] = actions.cycle_history_prev,
                            },
                        },
                        sorting_strategy = "ascending",

                        hidden = true,
                        use_fd = true,

                        results_title = "",
                        prompt_title = "",
                        preview_title = "",
                        prompt_prefix = " ",

                        layout_config = {
                            horizontal = {
                                width = 0.9,
                                height = 0.9,
                                prompt_position = "top",
                                preview_cutoff = 80,
                                preview_width = 0.5,
                            },
                            vertical = {
                                width = 0.9,
                                height = 0.9,
                                prompt_position = "top",
                                preview_cutoff = 20,
                                preview_width = 0.5,
                                preview_height = 0.5,
                            },
                        },
                    },
                    pickers = {
                        buffers = {
                            bufnr_width = 0,
                            sort_lastused = true,
                            prompt_title = "",
                            preview_title = "",
                        },
                        diagnostics = {
                            layout_strategy = "vertical",
                            path_display = "hidden",
                            prompt_title = "",
                            preview_title = "",
                        },
                        find_files = {
                            hidden = true,
                            find_command = { "fd", "--type", "f", "--hidden" },
                            prompt_title = "",
                            preview_title = "",
                        },
                        lsp_document_symbols = {
                            prompt_title = "",
                            preview_title = "",
                        },
                        live_grep = {
                            file_ignore_patterns = { 'node_modules', '.git', '.venv', 'CHANGELOG.md', 'poetry.lock' },
                            additional_args = function(_)
                                return { "--hidden" }
                            end,
                            prompt_title = "",
                            preview_title = "",
                        },
                        lsp_references = {
                            prompt_title = "",
                        },
                        -- FIXME: todo-comments picker doesn't respect these settings
                        ["todo-comments"] = {
                            preview_title = "",
                            prompt_title = "",
                        },
                    },
                })
            end,
        },

        -- Code actions with telescope
        {
            'nvim-telescope/telescope-ui-select.nvim',
            event = "VeryLazy",
            config = function()
                require("telescope").load_extension("ui-select")
            end,
        },

        -- Yaml Schemata
        {
            "someone-stole-my-name/yaml-companion.nvim",
            event = "VeryLazy",
            config = function()
                require("telescope").load_extension("yaml_schema")
            end,
        },

        -- Highlight TODO-style comments
        {
            "folke/todo-comments.nvim",
            event = "VeryLazy",
            dependencies = { "nvim-lua/plenary.nvim" },
            config = function()
                local todos = require("todo-comments")
                todos.setup({
                    keywords = {
                        SEE  = { icon = "󰈙 ", color = "hint", alt = { "DOC", "SOURCE", "URL", "REF" } },
                        NOTE = { icon = "󰀧 ", color = "hint", alt = { "INFO" } },
                        TODO = { icon = " ", color = "info", alt = { "Todo", "ToDo" } },
                        PERF = { icon = " ", color = "info", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
                        TEST = { icon = "󰙨 ", color = "warning", alt = { "TESTING", "PASSED", "FAILED" } },
                        HACK = { icon = "󰈸 ", color = "warning" },
                        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
                        FIX  = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE", "ERR", "ERROR" } },
                        -- FIX: create additional level for these
                        INOTE = { icon = "󰀧 ", color = "error" },
                    },
                    highlight = {
                        multiline = false,
                        pattern = [[.*<(KEYWORDS)\s*]],
                        keyword = "fg",
                        after = "",
                    },
                    colors = {
                        error = { "ErrorMsg" },
                        warning = { "WarningMsg" },
                        info = { "Todo", "Normal" },
                        hint = { "Comment" },
                    },
                })

                vim.keymap.set("n", "]t", todos.jump_next, {})
                vim.keymap.set("n", "[t", todos.jump_prev, {})
            end,
        },

        -- Restore last position in file
        -- NOTE: it's deprecated, but works just fine
        -- NOTE: we need it in addition to session restore
        {
            "ethanholz/nvim-lastplace",
            config = function()
                require("nvim-lastplace").setup({})
            end,
        },

        -- Restore all buffers and their positions
        {
            "rmagatti/auto-session",
            lazy = false, -- We need to restore session ASAP
            opts = {
                suppressed_dirs = { '~/', '/', '~/downloads' },
                session_lens = {
                    theme_conf = {
                        layout_strategy = "horizontal",
                        prompt_title = "",
                        layout_config = {
                            prompt_position = "top",
                            width = 60,
                            height = 30,
                        },
                    },
                },
            },
        },

        -- Floating filename per window (statusline stays hidden)
        {
            "b0o/incline.nvim",
            event = "VeryLazy",
            config = function()
                require("incline").setup({
                    window = {
                        margin = { vertical = 0, horizontal = 1 },
                    },
                    render = function(props)
                        local path = vim.api.nvim_buf_get_name(props.buf)
                        local filename = path == "" and "[no name]" or vim.fn.fnamemodify(path, ":t")
                        local modified = vim.bo[props.buf].modified and " •" or ""
                        return { filename .. modified }
                    end,
                })
            end,
        },

        -- Wakatime
        {
            "wakatime/vim-wakatime",
            lazy = false, -- As in official install
        },
    }
})

--------------
-- Settings --
--------------

-- Do not hide markdown elements in AI chat and documentation
vim.opt.conceallevel = 0

-- Disable swap files
vim.opt.swapfile = false

-- Increase gutter spacing
vim.opt.statuscolumn = "%s%=%l  "

-- Enable some mouse (for selections)
vim.opt.mouse = "nv"

-- Show line numbers
vim.opt.number = true

-- Disable fill character (in gutter)
vim.opt.fillchars = "eob: ,vert:¦"

-- Enable case-insensitive search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Disable soft wrapping
vim.opt.wrap = false

-- Merge command line and status line
vim.opt.cmdheight = 0

-- Tab as 4 spaces
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- Always keep sign column on
vim.opt.signcolumn = "yes"

-- Copy to system's clipboard
vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
end)

-- Save undo history
vim.opt.undofile = true

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Decrease update time. Used for swapfile and by gitsigns and local-highlight
vim.opt.updatetime = 25

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- White space characters
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '•', nbsp = '␣' }

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 6

-- Minimal number of screen columns to keep to the left and right of the cursor
vim.opt.sidescrolloff = 20

-- Scroll by screen line instead of jumping over wrapped lines
vim.opt.smoothscroll = true

-- Browser-like back/forward for the jumplist (see j/J keymaps)
vim.opt.jumpoptions = "stack"

-- Ask to save instead of erroring on :q with unsaved changes
vim.opt.confirm = true

-- Hide status line
vim.opt.laststatus = 0

-- Replace window splitter status line with a character
vim.opt.statusline = "%{repeat('⸺',winwidth('.'))}"

-- Remove welcome screen
vim.opt.shortmess:append("A")
vim.opt.shortmess:append("I") -- No intro
vim.opt.shortmess:append("s") -- Search wrap without message
vim.opt.shortmess:append("c") -- Unsuccessful search without prompt

-- Diagnostics
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN]  = "󰈸",
      [vim.diagnostic.severity.INFO]  = "󰋽",
      [vim.diagnostic.severity.HINT]  = "",
    },
  },
  underline = false,
  severity_sort = true,
})

-----------------
-- Keybindings --
-----------------

-- Leader key
vim.g.mapleader = " "

vim.keymap.set({ "n", "v" }, "<leader>t", "<cmd> TodoTelescope <cr>", {})
vim.keymap.set({ "n", "v" }, "<leader>f", "<cmd> Telescope find_files <cr>", {})
vim.keymap.set({ "n", "v" }, "<leader>k", "<cmd> Telescope keymaps <cr>", {})
vim.keymap.set({ "n", "v" }, "<leader>b", "<cmd> Telescope buffers <cr>", {})
vim.keymap.set({ "n", "v" }, "<leader>/", "<cmd> Telescope live_grep <cr>", {})
vim.keymap.set({ "n", "v" }, "<leader>j", "<cmd> Telescope jumplist <cr>", {})
vim.keymap.set({ "n", "v" }, "<leader>h", "<cmd> Telescope help_tags <cr>", {})
vim.keymap.set({ "n", "v" }, "<leader>d", "<cmd> Telescope diagnostics <cr>", {})
vim.keymap.set({ "n", "v" }, "<leader>s", "<cmd> Telescope lsp_document_symbols <cr>", {})
vim.keymap.set({ "n", "v" }, "<leader>S", "<cmd> Telescope lsp_workspace_symbols <cr>", {})
vim.keymap.set({ "n", "v" }, "<leader><leader>", "<cmd> Telescope resume <cr>", {})

vim.keymap.set({ "n", "v" }, "<leader>p", "<cmd> SessionSearch <cr>", {})
vim.keymap.set({ "n", "v" }, "<leader>o", function() require("oil").toggle_float() end, {})

-- WASD
vim.keymap.set({ "n", "v" }, "w", "gk", {})
vim.keymap.set({ "n", "v" }, "s", "gj", {})
vim.keymap.set({ "n", "v" }, "a", "h", {})
vim.keymap.set({ "n", "v" }, "d", "l", {})

vim.keymap.set({ "n", "v", "o" }, "q", "^", {})
vim.keymap.set({ "n", "v", "o" }, "e", "$", {})

vim.keymap.set({ "n", "v" }, "W", "5gk", {})
vim.keymap.set({ "n", "v" }, "S", "5gj", {})
vim.keymap.set({ "n", "v", "o" }, "A", "b", {})
vim.keymap.set({ "n", "v", "o" }, "D", "w", {})

vim.keymap.set({ "n", "v" }, "Q", "I", {})
vim.keymap.set({ "n", "v" }, "E", "A", {})

-- Movements
vim.keymap.set({ "n", "v" }, "ge", "G", {})

-- Windows
vim.keymap.set({ "n", "v" }, "<c-left>", "<c-w>h", {})
vim.keymap.set({ "n", "v" }, "<c-right>", "<c-w>l", {})
vim.keymap.set({ "n", "v" }, "<c-down>", "<c-w>j", {})
vim.keymap.set({ "n", "v" }, "<c-up>", "<c-w>k", {})

vim.keymap.set({ "i" }, "<c-left>", "<c-o><c-w>h", {})
vim.keymap.set({ "i" }, "<c-right>", "<c-o><c-w>l", {})
vim.keymap.set({ "i" }, "<c-down>", "<c-o><c-w>j", {})
vim.keymap.set({ "i" }, "<c-up>", "<c-o><c-w>k", {})

-- Jumps
vim.keymap.set({ "n", "v" }, "j", "<c-o>", {})
vim.keymap.set({ "n", "v" }, "J", "<c-i>", {})

-- Modifications
vim.keymap.set("v", "<", "<gv", {})
vim.keymap.set("v", ">", ">gv", {})

-- Undo
vim.keymap.set({ "n", "v" }, "U", "<c-r>", {})

-- Git
vim.keymap.set({ "n", "v" }, "gs", "<cmd> Telescope git_status <cr>", {})
vim.keymap.set({ "n", "v" }, "gl", "<cmd> Telescope git_bcommits <cr>", {})

-- Save
vim.keymap.set({ "n", "v", "i" }, "<c-s>", "<cmd> w <cr>", {})

-- Selections
vim.keymap.set({ "n", "v" }, "mw", "viw", {})
vim.keymap.set({ "n", "v" }, "mb", "vib", {})
vim.keymap.set({ "n", "v" }, "m(", "vib", {})
vim.keymap.set({ "n", "v" }, "mp", "vip", {})
vim.keymap.set({ "n", "v" }, "mq", "vi\"", {})
vim.keymap.set({ "n", "v" }, "m\"", "vi\"", {})

vim.keymap.set({ "n" }, "(", "vib", {})
vim.keymap.set({ "n" }, "\"", "vi\"", {})
vim.keymap.set({ "n" }, "{", "vi{", {})
vim.keymap.set({ "n" }, "[", "vi[", {})
vim.keymap.set({ "n" }, "<", "vi<", {})
vim.keymap.set({ "n" }, ">", "vit", {})
vim.keymap.set({ "n" }, "`", "vi`", {})

vim.keymap.set({ "v" }, "(", "<Plug>(nvim-surround-visual))", { remap = true, silent = true })
vim.keymap.set({ "v" }, ")", "<Plug>(nvim-surround-visual))", { remap = true, silent = true })
vim.keymap.set({ "v" }, "[", "<Plug>(nvim-surround-visual)]", { remap = true, silent = true })
vim.keymap.set({ "v" }, "]", "<Plug>(nvim-surround-visual)]", { remap = true, silent = true })
vim.keymap.set({ "v" }, "{", "<Plug>(nvim-surround-visual)}", { remap = true, silent = true })
vim.keymap.set({ "v" }, "}", "<Plug>(nvim-surround-visual)}", { remap = true, silent = true })
vim.keymap.set({ "v" }, "\"", "<Plug>(nvim-surround-visual)\"", { remap = true, silent = true })
vim.keymap.set({ "v" }, "\'", "<Plug>(nvim-surround-visual)\'", { remap = true, silent = true })
vim.keymap.set({ "v" }, "`", "<Plug>(nvim-surround-visual)`", { remap = true, silent = true })
vim.keymap.set({ "n" }, "t", "<Plug>(nvim-surround-change)t", { remap = true, silent = true })
vim.keymap.set({ "v" }, "t", "<Plug>(nvim-surround-visual)t", { remap = true, silent = true })

-- Select all
vim.keymap.set({ "n", "v" }, "%", "ggVG", {})

-- LSP
vim.keymap.set({ "n", "v" }, "gd", vim.lsp.buf.definition, {})
vim.keymap.set({ "n", "v" }, "gr", "<cmd> Telescope lsp_references <cr>", {})
vim.keymap.set({ "n", "v" }, "h", vim.lsp.buf.hover, {})
vim.keymap.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, {})
vim.keymap.set({ "n", "v" }, "<leader>r", vim.lsp.buf.rename, {})
vim.keymap.set({ "n", "v" }, "<c-f>", function() require("conform").format() end, {})

-- Commenting
vim.keymap.set({ "v", "x" }, "<c-c>", "gcgv", { remap = true })
vim.keymap.set({ "n" }, "<c-c>", "gcc", { remap = true })

-- Journaling
local function insert_date()
    local date = os.date("%Y-%m-%d")
    vim.api.nvim_put({ date }, "c", true, true)
end

vim.keymap.set({ "n", "v" }, "T", insert_date, {})
vim.keymap.set({ "n", "v", "i" }, "<c-s-t>", insert_date, {})

-- Completion
-- Some advanced but very practical and easy to use logic:
--   Continue nvim-cmp completion, if it's already active
--   Accept copilot suggestion, if any
--   Use nvim-cmp, if any
--   If in insert mode, insert tab
local function tab_complete()
    local copilot = require("copilot.suggestion")
    local cmp = require("cmp")

    if cmp.get_selected_index() ~= nil then
        return cmp.select_next_item()
    end

    if copilot.is_visible() then
        return copilot.accept()
    end

    if cmp.visible() then
        return cmp.select_next_item()
    end

    if vim.api.nvim_get_mode().mode == "i" then
        vim.fn.feedkeys("\t")
        return
    end
end

-- Enter completion
-- Again, some advanced logic to simplify completion usage
--   If there is SELECTED completion, accept it
--   Feed enter key otherwise
local function enter_complete()
    local cmp = require("cmp")

    if cmp.get_selected_index() ~= nil then
        return cmp.confirm()
    end

    vim.fn.feedkeys("\n")
end

local function esc_complete()
    local cmp = require("cmp")
    local copilot = require("copilot.suggestion")

    if cmp.visible() and copilot.is_visible() then
        return cmp.close()
    end

    vim.fn.feedkeys("\027")
end

vim.keymap.set({ "i" }, "<tab>", tab_complete, {})
vim.keymap.set({ "i" }, "<cr>", enter_complete, {})
vim.keymap.set({ "i" }, "<esc>", esc_complete, {})

-- Don't modify clipboard
vim.keymap.set({ "n", "v" }, "X", '"_x', {})
vim.keymap.set({ "n", "v" }, "c", '"_c', {})
vim.keymap.set({ "x", "v" }, "p", 'P', {})
vim.keymap.set({ "x", "v" }, "P", 'P', {})
vim.keymap.set({ "n" }, "V", '"_V', {})

-- Semicolon to colon
vim.keymap.set({ "n", "v" }, ";", ":", {})

-- Enable reading local .nvimrc files
vim.opt.exrc = true

----------------------------------
--- Smart TODO-list checkboxes ---
----------------------------------

local function insert_todo()
    local todo_prefix = "- [ ] "
    local cursor = vim.api.nvim_win_get_cursor(0)
    local row = cursor[1]
    local col = cursor[2]
    local line = vim.api.nvim_get_current_line()

    local insert_at_eol

    if line:sub(1, col):match("^%s*$") then
        local suffix = line:sub(col + 1)

        vim.api.nvim_set_current_line(todo_prefix .. suffix)
        insert_at_eol = suffix == ""
    else
        vim.api.nvim_buf_set_lines(0, row, row, false, { todo_prefix })
        row = row + 1
        insert_at_eol = true
    end

    if insert_at_eol then
        -- Normal-mode cursor must remain on the final space.
        vim.api.nvim_win_set_cursor(0, { row, #todo_prefix - 1 })

        -- Behaves like "A": enters Insert mode after the final space.
        vim.cmd("startinsert!")
    else
        -- Cursor can point at the first suffix character.
        vim.api.nvim_win_set_cursor(0, { row, #todo_prefix })
        vim.cmd.startinsert()
    end
end

vim.keymap.set({ "n" }, "t", insert_todo, {})
vim.keymap.set({ "n", "i", "v" }, "<c-t>", insert_todo, {})

--------------------------------
--- Termux specific settings ---
--------------------------------

local is_termux = vim.fn.has("termux") == 1
  or vim.env.TERMUX_VERSION ~= nil

if is_termux then
  vim.opt.number = false
  vim.opt.relativenumber = false
  vim.opt.signcolumn = "no"

  vim.opt.wrap = true
  vim.opt.linebreak = true
  vim.opt.breakindent = true
end
