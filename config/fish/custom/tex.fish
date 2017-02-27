set -l tex_dir /Library/TeX/texbin

if test -d $tex_dir
  set -gx PATH $tex_dir $PATH
end

