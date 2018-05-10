# Loads the standard math library when using bc, which is used by the fish
# shell built-in `math` function. This allows arbitrary-precision division (not
# just integer division) if there is a `~/.bc.cfg` that specifies a scale, e.g.
# `scale = 5`.
#
# update: turning this off for now, as there are some things in fish shell
# which currently rely on `math` doing integer division, and apparently with
# `bc` you can't have it both ways -- it will either do integer or
# floating-point division.
#
# set -gx BC_ENV_ARGS $HOME/.bc.cfg
# function bc
# 	command bc -l $argv;
# end

# translate Bash `export x=42` syntax into fish `set -gx x 42` syntax, so I can
# copy-paste Bash export snippets into my fish terminal
function export
  set arr (echo $argv|tr = \n)
  set -gx $arr[1] $arr[2]
end

# make pbcopy and pbpaste available when not using OS X, via xsel
if not which pbcopy >/dev/null; and which xsel >/dev/null
  function pbcopy
    cat 1>| xsel --clipboard --input
  end
end

if not which pbpaste >/dev/null; and which xsel >/dev/null
  function pbpaste
    xsel --clipboard --output
  end
end

# (OS X) show/hide hidden files in Finder
function hidefiles
	defaults write com.apple.finder AppleShowAllFiles -bool false; and killall Finder;
end

function showfiles
	defaults write com.apple.finder AppleShowAllFiles -bool true; and killall Finder;
end

# (OS X) open a file/folder in Light Table
function light-table
	open -a /Applications/LightTable/LightTable.app $argv;
end

# alias lt = light-table
function lt
	light-table $argv;
end

# alias pt = papertrail
function pt
	papertrail $argv;
end

# shrug emojis are vitally important to my workflow
function copy_shrug
  set shrug $argv[1]
	printf "$shrug" | pbcopy
  echo "shrug copied to clipboard $shrug"
end

function shrug; copy_shrug '¯\_(ツ)_/¯'; end
function shrug2; copy_shrug 'ㄟ( ･ө･ )ㄏ'; end
function shrug3; copy_shrug "┐('～`;)┌"; end
function shrug4; copy_shrug '┐(￣ヘ￣;)┌'; end
function shrug5; copy_shrug '╮(￣ω￣;)╭ '; end

# strip ANSI color codes
function stripcolor
	sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" $argv;
end

# strip trailing whitespace from file
function stripwhitespace
  sed -i 's/[[:space:]]\+$//' $argv;
end

# copy N random GitHub-style emoji codes (e.g. :panda_face:) to clipboard
function randomoji
  set emoji (eval $CODEDIR/randomoji/randomoji $argv[1])
  printf $emoji | pbcopy
  echo "$emoji copied to clipboard"
end

# for some reason, gnu-parallel is significantly slower when $SHELL is not bash.
# Temporarily setting SHELL to bash makes it a lot faster.
# source: https://github.com/fish-shell/fish-shell/issues/1084#issuecomment-27746587
function parallel
  set -lx SHELL bash
  command parallel $argv
end

