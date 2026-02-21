return {
    "3rd/image.nvim",
    build = false,
    event = "VeryLazy",
    opts = {
        backend = "kitty",
        processor = "magick_cli",
        hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif", "*.svg" },
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
        require("image").setup(opts)

        -- SVG support: convert to temp PNG via ImageMagick, then display
        vim.api.nvim_create_autocmd("BufReadCmd", {
            pattern = { "*.svg", "*.svgz" },
            callback = function(args)
                local svg_path = vim.fn.expand("%:p")
                local tmp_png = vim.fn.tempname() .. ".png"
                local cmd = string.format("magick '%s' -density 300 -background none '%s'", svg_path, tmp_png)
                local result = vim.fn.system(cmd)
                if vim.v.shell_error ~= 0 then
                    vim.notify("SVG convert failed: " .. result, vim.log.levels.ERROR)
                    return
                end
                -- Load the converted PNG into the buffer
                vim.cmd.edit(tmp_png)
                -- Clean up temp file on buffer close
                vim.api.nvim_create_autocmd("BufDelete", {
                    buffer = 0,
                    once = true,
                    callback = function()
                        os.remove(tmp_png)
                    end,
                })
            end,
        })
    end,
}
