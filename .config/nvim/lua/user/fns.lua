return {
  nmap = function (key_sequence, fn)
    vim.keymap.set('n', key_sequence, fn)
  end,
}
