#!/usr/bin/env python3
import sys
import os
import re
import html

# Default paths to check for sxhkdrc
DEFAULT_PATHS = [ os.path.expanduser("~/.config/sxhkd/sxhkdrc") ]

# Expand ranges like '1-5' or 'a-c' into individual elements
def expandRanges(part):
    part = part.strip()
    if '-' in part:
        subparts = part.split('-')
        if len(subparts) == 2:
            start, end = subparts[0].strip(), subparts[1].strip()
            if start.isdigit() and end.isdigit():
                return [str(i) for i in range(int(start), int(end) + 1)]
            elif len(start) == 1 and len(end) == 1:
                return [chr(c) for c in range(ord(start), ord(end) + 1)]
    return [part]

# Recursively expand sxhkd brace syntax including ranges
def expandHotkey(hotkey):
    startIdx = hotkey.find('{')
    if startIdx == -1:
        return [hotkey]
    endIdx = hotkey.find('}', startIdx)
    if endIdx == -1:
        return [hotkey]
    prefix = hotkey[:startIdx]
    body = hotkey[startIdx+1:endIdx]
    suffix = hotkey[endIdx+1:]
    parts = body.split(',')
    options = []
    for p in parts:
        if p == '_':
            options.append('')
        else:
            options.extend(expandRanges(p))
    results = []
    for opt in options:
        results.extend(expandHotkey(prefix + opt + suffix))
    return results

# Clean and normalize spaces in keybindings
def cleanShortcut(shortcut):
    shortcut = re.sub(r'\s+', ' ', shortcut).strip()
    shortcut = re.sub(r'\s*\+\s*', ' + ', shortcut)
    return shortcut.replace('@', '')


def main():
    configPath = sys.argv[1] if len(sys.argv) > 1 else DEFAULT_PATHS[0]
    if not os.path.exists(configPath):
        found = False
        for p in DEFAULT_PATHS:
            if os.path.exists(p):
                configPath = p
                found = True
                break
        if not found:
            print(f"[ERROR] Config file not found: {configPath}", file=sys.stderr)
            sys.exit(1)

    commentLines = []
    with open(configPath, 'r', encoding='utf-8') as f:
        for line in f:
            stripped = line.strip()
            if not stripped:
                commentLines = []
                continue
            if line.startswith('#'):
                # Ignore section dividers starting with #* or #!
                if not (line.startswith('#*') or line.startswith('#!')):
                    commentLines.append(line.lstrip('#').strip())
                continue
            if line.startswith(' ') or line.startswith('\t'):
                continue

            # Parse hotkey line
            hotkeys = expandHotkey(stripped)
            description = " ".join(commentLines).strip() if commentLines else "No description"
            if description:
                description = description[0].upper() + description[1:]

            escapedDesc = html.escape(description)
            for hk in hotkeys:
                clean_hk = html.escape(cleanShortcut(hk))
                # Output using a single tab separator for Rofi tab-stops alignment
                print(f"{escapedDesc}\t<span color='#BD93F9'>{clean_hk}</span>")
            commentLines = []

if __name__ == '__main__':
    main()
