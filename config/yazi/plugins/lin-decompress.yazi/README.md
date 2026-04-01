# lin-decompress

A [yazi plugin](https://github.com/sxyazi/yazi) to extract each archive using a specialized tool for **Linux**.

Map a variety of different extractor tools to their archive(s) for extraction.

## Support

`lin-decompress` is customizable enough to support many archives & extractor tools.
The table below shows how `lin-decompress` utilizes each of the _default_ extractor tools.

| Extension | Tools | Commands |
| ---------- | -------- | ------- |
| `.rar` | `unrar` |`unrar x -op<output> -p<pw>` |
| `.tar`,`.tar.*` | `tar` | `tar -xf <archive> --overwrite -C <output> (-I <tar.* commands>)`|
|`.lz4` | `lz4` | `lz4 -dkc <archive>` |
| `.xz` | `xz` | `xz -T0 -dkc <archive>` |
| `.gz`| `gzip` | `gzip -dkc <archive>` |
| `.bz2` | `bzip2` | `bzip2 -dkc <archive>` |
| `.zst` | `zstd`| `zstd -T0 -dkc <archive>`|
| `.lzo` |`lzop` | `lzop -dkc <archive>` |
| `.lz` | `lzip`| `lzip -dkc <archive>` |
| `.lzma` | `lzma` | `lzma -dkc <archive>`|
| _(default)_ `.*`| `7zip` | `7z x -mmt=0 -o<output> -p<pw>` |

## Installation

```bash
# Method 1
git clone https://github.com/ZimCodes/lin-decompress.yazi ~/.config/yazi/plugins/lin-decompress.yazi/main.lua

# Method 2
ya pkg add ZimCodes/lin-decompress
```

## Setup

After installation, here are some things you need to setup.

### Init.lua

You **must** copy the entire code found in [`INIT.md`](./INIT.md) to your `init.lua`.
Afterwards, read the comments for guidelines on mapping your extractor tool(s)
to their archive(s). If you are okay with the defaults, then you're all set!

### Keymap

Customize your keymap to your liking. Here's one you can add to your `keymap.toml`:

```toml
[[mgr.prepend_keymap]]
on = ["x","x","x"]
run = "plugin lin-decompress -- --no-password"
desc = "Extract hovered."

[[mgr.prepend_keymap]]
on = ["x","x","p"]
run = "plugin lin-decompress"
desc = "Extract hovered. Password"

[[mgr.prepend_keymap]]
on = ["x","x","a"]
run = "plugin lin-decompress -- --no-hover --tabselect=all"
desc = "Extract selected in all tabs"

[[mgr.prepend_keymap]]
on = ["x","x","A"]
run = "plugin lin-decompress -- --tabselect=all"
desc = "Extract selected in all tabs. Hovered included"

[[mgr.prepend_keymap]]
on = ["x","x","c"]
run = "plugin lin-decompress -- --no-hover --tabselect=current"
desc = "Extract selected in current tab only"
```

## Options

_**--no-hover**_

Do not extract the file you're currently hovering over. By default, hovered files are extracted.

_**--tabselect=`SELECT_TYPE`**_

`SELECT_TYPE` choices:

- `all`
  - Gets selected files from all tabs
- `current` or `active`
  - Gets selected files from current tab
- `<nothing>` _(default)_
  - Does not get selected files from any tabs

_**--no-password**_

Do not prompt for password. By default, when an extractor with the ability to use a password is used, the user will be prompt for password.

_Alternatively_, when prompt appears, users can enter `!!!` to temporarily disable prompting for the current run.

## License

`lin-decompress` uses the [MIT License](./LICENSE).
