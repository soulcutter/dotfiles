# Human-readable disk usage sorted by size
function duh() {
  echo "$@"
  du -h "$@" | awk '{if ($1 != "0B" && $1 != "4.0K") printf "%s %08.2f\t%s\n", index("KMG", substr($1, length($1))), substr($1, 0, length($1)-1), $0}' | sort -r | cut -f2,3 | less -FX
}
