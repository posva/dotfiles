# Run from the new worktree root. Keep configuration local to this install.
function posva_worktree_setup() {
  [[ -f pnpm-lock.yaml || -f pnpm-workspace.yaml ]] || return 0

  if ! command -v pnpm >/dev/null 2>&1; then
    _wt_log warn "pnpm not found; skipped dependency setup. Run posva_worktree_setup after installing pnpm."
    return 0
  fi

  _wt_log info "installing pnpm dependencies with the global virtual store"
  PNPM_CONFIG_VIRTUAL_STORE_TYPE=global pnpm install --frozen-lockfile
}
