set -l lilypond_dir /Applications/LilyPond.app/Contents/Resources/bin

if test -d $lilypond_dir
  set -gx PATH $lilypond_dir $PATH
end

