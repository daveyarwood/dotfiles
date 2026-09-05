" copy & paste to system clipboard
let g:os = substitute(system('uname'), '\n', '', '')
if g:os == 'Linux'
  nnoremap <Space>y "+y
  vnoremap <Space>y "+y
  nnoremap <Space>d "+d
  vnoremap <Space>d "+d
  nnoremap <Space>p "+p
  vnoremap <Space>p "+p
  nnoremap <Space>P "+P
  vnoremap <Space>P "+P
else
  nnoremap <Space>y "*y
  vnoremap <Space>y "*y
  nnoremap <Space>d "*d
  vnoremap <Space>d "*d
  nnoremap <Space>p "*p
  vnoremap <Space>p "*p
  nnoremap <Space>P "*P
  vnoremap <Space>P "*P
endif

