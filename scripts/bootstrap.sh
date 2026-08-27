#!/usr/bin/env zsh
set -euo pipefail

DEPS=(git stow)
GIT_REMOTE="https://github.com/rafalberezin/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"
IGNORE_DIRS=(.git scripts)
GLOBAL_ZSHENV=("/etc/zsh/zshenv")
NO_LINK_DIRS=("$HOME/.local/bin" "$HOME/.local/share" "$HOME/.local/state")

USAGE_PATH="$0"
usage() {
	cat <<EOF
Usage: $USAGE_PATH [options]

Bootstrap dotfiles setup.

Options:
  -h, --help       Show this help message
  -n, --no-backup  Do not backup existing configuration
  -q, --quiet      Suppress informational messages
  -g, --no-global  Skip global configuration requiring sudo

EOF
}

BACKUP=true
QUIET=false
GLOBAL=true

while [[ $# -gt 0 ]]; do
	case "$1" in
		-h|--help)
			usage
			exit 0
			;;
		-n|--no-backup)
			BACKUP=false
			;;
		-q|--quiet)
			QUIET=true
			;;
		-g|--no-global)
			GLOBAL=false
			;;
		*)
			echo "Unknown option: $1" >&2
			exit 1
			;;
	esac

	shift
done

info() {
	if ! $QUIET; then
		printf '[INFO] %s\n' "$1"
	fi
}

error() {
	if ! $QUIET; then
		printf '[ERROR] %s\n' "$1" >&2
	fi
}

run() {
	if ! $QUIET; then
		printf '[RUN] %s\n' "$1"
	fi
	eval "$1"
}

info "checking dependencies"

MISSING_DEPS=()

for DEP in $DEPS; do
	if ! command -v $DEP >/dev/null 2>&1; then
		MISSING_DEPS+=("$DEP")
	fi
done

if (( ${#MISSING_DEPS} )); then
	error "missing dependencies: $MISSING_DEPS"
	exit 1
fi

BACKUP_DIR=""
BACKUP_MANIFEST=""
BACKUP_TARGETS=()
typeset -U BACKUP_TARGETS

if $BACKUP; then
	TIMESTAMP="$(date +%Y-%m-%d_%H-%M-%S)"

	BACKUP_DIR="$HOME/dotfiles-backup-$TIMESTAMP"
	mkdir "$BACKUP_DIR"

	BACKUP_MANIFEST="$BACKUP_DIR/manifest.md"

	if [[ -d "$DOTFILES_DIR" ]]; then
		info "backing up existing dotfiles directory"
		mv "$DOTFILES_DIR" "$BACKUP_DIR"
	fi
fi

info "downloading dotfiles"

git clone -q "$GIT_REMOTE" "$DOTFILES_DIR"
cd "$DOTFILES_DIR"

DIRS=(*/(N:t))
STOW_TARGETS=(${DIRS:|IGNORE_DIRS})

if $BACKUP; then
	info "backing up existing configuration"

	for TARGET in $STOW_TARGETS; do
		DIRS=("$TARGET"/*(ND:t))
		if (( ${#DIRS} )); then
			BACKUP_TARGETS+=$DIRS
		fi
	done

	BACKEDUP=()
	for TARGET in $BACKUP_TARGETS; do
		if [[ -e "$HOME/$TARGET" ]]; then
			mv "$HOME/$TARGET" "$BACKUP_DIR"
			BACKEDUP+=$TARGET
		fi
	done

	echo "# Dotfiles backup manifest" > "$BACKUP_MANIFEST"
	echo "" >> "$BACKUP_MANIFEST"

	if (( ${#BACKEDUP} )); then
		echo "## Local backup:" >> "$BACKUP_MANIFEST"
		echo "" >> "$BACKUP_MANIFEST"

		for TARGET in $BACKEDUP; do
			echo "- $HOME/$TARGET -> $BACKUP_DIR/$TARGET" >> "$BACKUP_MANIFEST"
		done

		echo "" >> "$BACKUP_MANIFEST"
	fi

	if $GLOBAL; then
		if run "sudo test -e \"$GLOBAL_ZSHENV\""; then
			info "backing up global zshenv"

			TARGET="$BACKUP_DIR/zshenv_global"

			run "sudo mv \"$GLOBAL_ZSHENV\" \"$TARGET\""

			echo "## Global backup:" >> "$BACKUP_MANIFEST"
			echo "" >> "$BACKUP_MANIFEST"
			echo "- $GLOBAL_ZSHENV -> $TARGET" >> "$BACKUP_MANIFEST"
			echo "" >> "$BACKUP_MANIFEST"
		fi
	fi
fi

info "stowing dotfiles"
for TARGET in $NO_LINK_DIRS; do
	mkdir -p "$TARGET"
done
stow $STOW_TARGETS

if $GLOBAL; then
	info "setting global zshenv"
	run "sudo cp global_zshenv \"$GLOBAL_ZSHENV\""
fi

info "Done"

