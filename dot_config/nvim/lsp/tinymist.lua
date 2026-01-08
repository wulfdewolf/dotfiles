return {
  cmd = { "tinymist" },
  filetypes = { "typ", "typst" },
  root_markers = { "typ.toml", "typst.toml" },
  settings = {
    formatterMode = "typstyle",
    semanticTokens = "disable",
    formatterProseWrap = true,
    formatterPrintWidth = 88,
  },
}
