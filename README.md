# dotfiles

My personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/stow.html)

## What's inside

Each top-level directory is a stow package, except `scripts/` and `.git/`.

File `global_zshenv` is copied to `/etc/zsh/zshenv`,
which loads the current user's `~/.config/environment.d/10-base.conf`
containing `XDG` base directories and `ZDOTDIR` env vars.
This step requires `sudo` and can be skipped with `-g` / `--no-global` flags.

## Requirements

- `git`
- `stow`
- `zsh`
- `sudo` (for `/etc/zsh/zshenv`)

## Installation

Run the bootstrap script directly:

```bash
curl -fsSL https://raw.githubusercontent.com/rafalberezin/dotfiles/master/scripts/bootstrap.sh | zsh
```

This:
- backs up existing configuration
- clones the repo to `~/dotfiles`
- symlinks new config via `stow`
- sets up `/etc/zsh/zshenv`

### Options

```
  -h, --help       Show this help message
  -n, --no-backup  Do not backup existing configuration
  -q, --quiet      Suppress informational messages
  -g, --no-global  Skip global configuration requiring sudo
```

Example, skipping backup

```
curl -fsSL https://raw.githubusercontent.com/rafalberezin/dotfiles/master/scripts/bootstrap.sh | zsh -s -- --no-backup
```

Example, skipping globals (no sudo)

```
curl -fsSL https://raw.githubusercontent.com/rafalberezin/dotfiles/master/scripts/bootstrap.sh | zsh -s -- --no-global
```

## Backups

By default the script backs up:
- existing `~/dotfiles` dir, if present
- any files and dirs in home that would conflict with stow
- `/etc/zsh/zshenv`, if present

Everything is moved to a timestamped `~/dotfiles-backup-<date>/` directory,
with `manifest.md`, listing what was moved.

Use `-n` / `--no-backup` to skip this.

## License

MIT - see [LICENSE](LICENSE).

