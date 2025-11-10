alias be="bundle exec"

if [ -f "${HOME}/.gemrc.local" ]; then
  export GEMRC="${HOME}/.gemrc.local"
fi

# Running puma locally can sometimes result in errors in the form
# objc[83746]: +[__NSCFConstantString initialize] may have been in progress in another thread when fork() was called.
# objc[83746]: +[__NSCFConstantString initialize] may have been in progress in another thread when fork() was called. We cannot safely call it or ignore it in the fork() child process. Crashing instead. Set a breakpoint on objc_initializeAfterForkError to debug.
#
# I really don't understand, but this fixes that problem:
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=yes
