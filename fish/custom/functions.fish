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

# table flip emojis sometimes useful

function tableflip
  set flip '(╯°□°)╯︵ ┻━┻'
  printf "$flip" | pbcopy
  echo "table flip copied to clipboard $flip"
end

# strip ANSI color codes
function stripcolor
	sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" $argv;
end

# strip trailing whitespace from file
function stripwhitespace
  sed -i 's/[[:space:]]\+$//' $argv;
end
