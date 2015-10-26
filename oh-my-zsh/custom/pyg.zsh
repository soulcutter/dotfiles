# Adapted from https://gist.github.com/simono/9379347

# 1. Run pygmentize on file
# 2. Set the fontsize to 18 Points (=36 half-points)
# 3. Remove all newlines
# 4. Remove trailing paragraph, to prevent a line break
# 5. Copy the result to the clipboard
function pyg() {
  local style="${2-default}";
  pygmentize -f rtf -O "fontface=Monaco,style=${style}" $1 | sed 's;\\f0;\\f0\\fs36;g' | tr -d '\n' | sed 's;\\par}$;};' | pbcopy
}
