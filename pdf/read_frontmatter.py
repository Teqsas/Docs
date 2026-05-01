#!/usr/bin/env python3
# Read a single YAML frontmatter field from a Markdown file.
# Usage: read_frontmatter.py <path> <key> [default]
# Exit 0 always; missing file or key prints the default (or empty string).
# Only handles flat 'key: value' YAML — that's all the docs need.

import re
import sys


def main() -> int:
    if len(sys.argv) < 3:
        print("usage: read_frontmatter.py <path> <key> [default]", file=sys.stderr)
        return 2
    path = sys.argv[1]
    key = sys.argv[2]
    default = sys.argv[3] if len(sys.argv) > 3 else ""

    try:
        with open(path, "r", encoding="utf-8") as f:
            text = f.read()
    except FileNotFoundError:
        print(default)
        return 0

    m = re.match(r"^---\s*\n(.*?)\n---\s*\n", text, re.DOTALL)
    if not m:
        print(default)
        return 0

    for line in m.group(1).split("\n"):
        line_match = re.match(r"^([A-Za-z_][\w-]*)\s*:\s*(.*?)\s*$", line)
        if not line_match or line_match.group(1) != key:
            continue
        value = line_match.group(2)
        if (value.startswith('"') and value.endswith('"')) or (
            value.startswith("'") and value.endswith("'")
        ):
            value = value[1:-1]
        print(value)
        return 0

    print(default)
    return 0


if __name__ == "__main__":
    sys.exit(main())
