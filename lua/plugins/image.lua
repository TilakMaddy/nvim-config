-- Rasterize an SVG with rsvg-convert (ImageMagick's built-in SVG renderer chokes on text/fonts).
-- Results are cached by path + mtime + size so reopening is instant.
local function svg_to_png(svg)
    local stat = vim.uv.fs_stat(svg)
    if not stat then
        return nil
    end
    local cache_dir = vim.fn.stdpath "cache" .. "/image-svg"
    vim.fn.mkdir(cache_dir, "p")
    local png = ("%s/%s.png"):format(cache_dir, vim.fn.sha256(svg .. stat.mtime.sec .. stat.size))
    if not vim.uv.fs_stat(png) then
        local res = vim.system({ "rsvg-convert", "--zoom", "2", "--output", png, svg }):wait()
        if res.code ~= 0 then
            vim.notify("SVG render failed: " .. (res.stderr or ""), vim.log.levels.ERROR)
            return nil
        end
    end
    return png
end

return {
    "3rd/image.nvim",
    build = false,
    -- Must be loaded before the first buffer is shown, or `nvim foo.png` won't be hijacked
    lazy = false,
    opts = {
        backend = "kitty",
        processor = "magick_cli",
        hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
        max_height_window_percentage = 50,
        window_overlap_clear_enabled = true,
        integrations = {
            markdown = {
                enabled = true,
                download_remote_images = true,
                only_render_image_at_cursor = false,
            },
        },
    },
    config = function(_, opts)
        local image = require "image"
        image.setup(opts)

        -- SVGs: render to PNG, then display it in the SVG's own buffer.
        -- <leader>i toggles between the preview and the editable source.
        local group = vim.api.nvim_create_augroup("image_svg", { clear = true })
        local images = {} -- buf -> Image currently shown for it

        local function clear_preview(buf)
            local img = images[buf]
            if img then
                img:clear()
                -- drop image.nvim's win:buf cache so the next preview uses the fresh PNG
                for key, cached in pairs(img.global_state.hijacked_win_buf_images) do
                    if cached == img then
                        img.global_state.hijacked_win_buf_images[key] = nil
                    end
                end
                images[buf] = nil
            end
        end

        local function show_preview(buf)
            if vim.b[buf].svg_source then
                return
            end
            if vim.fn.executable "rsvg-convert" == 0 then
                vim.notify("SVG preview needs rsvg-convert: brew install librsvg", vim.log.levels.WARN)
                return
            end
            local png = svg_to_png(vim.api.nvim_buf_get_name(buf))
            if png then
                images[buf] = image.hijack_buffer(png, vim.api.nvim_get_current_win(), buf)
            end
        end

        local function toggle(buf)
            if vim.b[buf].svg_source then
                if vim.bo[buf].modified then
                    vim.cmd.write()
                end
                vim.b[buf].svg_source = false
                show_preview(buf)
            else
                clear_preview(buf)
                vim.b[buf].svg_source = true
                vim.bo[buf].buftype = ""
                vim.bo[buf].modifiable = true
                vim.cmd "edit! | setlocal number< signcolumn< cursorline< colorcolumn<"
            end
        end

        vim.api.nvim_create_autocmd({ "BufWinEnter", "WinNew", "TabEnter" }, {
            group = group,
            pattern = { "*.svg", "*.svgz" },
            callback = function(args)
                vim.keymap.set("n", "<leader>i", function()
                    toggle(args.buf)
                end, { buffer = args.buf, desc = "Toggle SVG preview/source" })
                show_preview(args.buf)
            end,
        })

        vim.api.nvim_create_autocmd("BufWipeout", {
            group = group,
            pattern = { "*.svg", "*.svgz" },
            callback = function(args)
                clear_preview(args.buf)
            end,
        })
    end,
}
