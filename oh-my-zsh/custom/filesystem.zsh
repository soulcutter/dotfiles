# Human-readable disk usage sorted by size
function duh() {
  echo "$@"
  du -h "$@" | awk '{if ($1 != "0B" && $1 != "4.0K") printf "%s %08.2f\t%s\n", index("KMG", substr($1, length($1))), substr($1, 0, length($1)-1), $0}' | sort -r | cut -f2,3 | less -FX
}

function backup() {
  local directory=$(dirname $1)
  local prefix="$(basename $1).$(date '+%Y%m%d')v"
  local i=0
  while  [ -f "$directory/$prefix$i" ]; do
    ((i++))
  done
  cp $1 $directory/$prefix$i
  echo "Backed up to $directory/$prefix$i"
}
