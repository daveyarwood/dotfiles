for f in split(glob('~/.vim/custom/*.vim'), '\n')
  exe 'source' f
endfor
