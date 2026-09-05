" Don't close window when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt() abort
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction

nnoremap H :bp<CR>
nnoremap L :bn<CR>
nnoremap <leader>, :b#<CR>
nnoremap Q :bp <BAR> bd #<CR>

" Close the current buffer
nnoremap <leader>bd :Bclose<cr>

" closes all buffers except for the current one
" (doesn't close any buffers with unsaved changes)
nnoremap <leader>bo :BufOnly<CR>
" creates an empty buffer and closes everything else
" (doesn't close any buffers with unsaved changes)
nnoremap <leader>bD :enew<CR>:BufOnly<CR>

