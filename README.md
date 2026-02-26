# ghostty-random-theme

A random [Ghostty](https://ghostty.org) theme on every new terminal session.

Each time you open a new tab, window, or split, a theme is picked at random from Ghostty's 400+ built-in themes and applied instantly via OSC escape sequences. No config files are modified — colors are set in-memory for that session only.

## Why

Someone [asked for this in the Ghostty repo](https://github.com/ghostty-org/ghostty/discussions/3577) and a contributor correctly pointed out that a shell-level solution is the right approach. Here it is.

## Install

### zsh (macOS default)

```bash
git clone https://github.com/merinids212/ghostty-random-theme.git ~/.ghostty-random-theme

# add to your .zshrc
source ~/.ghostty-random-theme/random-theme.zsh
```

### bash (most Linux distros)

```bash
git clone https://github.com/merinids212/ghostty-random-theme.git ~/.ghostty-random-theme

# add to your .bashrc
source ~/.ghostty-random-theme/random-theme.bash
```

Open a new terminal. That's it.

## How it works

On shell startup, the script:

1. Checks if you're running inside Ghostty (`TERM_PROGRAM`)
2. Finds the built-in themes directory via `GHOSTTY_RESOURCES_DIR` (set by Ghostty on all platforms), with fallbacks for standard install paths
3. Picks one at random using bash/zsh built-in `$RANDOM` — no external dependencies
4. Parses the theme file and applies colors via [OSC escape sequences](https://invisible-island.net/xterm/ctlseqs/ctlseqs.html)
5. Prints the theme name so you know what you got

Your Ghostty config file is never touched. Each session gets its own random theme independently.

## Curating themes

If 400+ themes is too chaotic, you can limit it to a favorites list.

In your shell's script, find the "Pick a random theme" section and replace it with a hardcoded array:

**zsh** — replace lines 14–20 in `random-theme.zsh`:

```zsh
# Pick a random theme (favorites only)
_favorites=("TokyoNight Night" "Catppuccin Mocha" "Dracula" "Gruvbox Dark")
_theme="${_favorites[RANDOM % $#_favorites + 1]}"
_theme_file="$_ghostty_themes_dir/$_theme"
```

**bash** — replace lines 23–28 in `random-theme.bash`:

```bash
# Pick a random theme (favorites only)
_favorites=("TokyoNight Night" "Catppuccin Mocha" "Dracula" "Gruvbox Dark")
_theme="${_favorites[RANDOM % ${#_favorites[@]}]}"
_theme_file="$_ghostty_themes_dir/$_theme"
```

## License

MIT
