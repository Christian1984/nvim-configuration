local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
    return
end

bufferline.setup({
  options = {
    mode = "buffers",
    separator_style = "slant",
    always_show_bufferline = true,
    show_buffer_close_icons = true,
    show_close_icon = true,
    color_icons = true,
    diagnostics = "nvim_lsp",
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        text_align = "left",
        separator = true,
      },
    },
  },
})
