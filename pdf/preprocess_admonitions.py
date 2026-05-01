#!/usr/bin/env python3
# Convert MkDocs/Material admonitions ("!!! type \"title\"" + 4-space-indented
# body) into Pandoc fenced divs (::: {.admonition .type title="..."}). Reads
# stdin, writes stdout.

import re
import sys

ADMONITION_RE = re.compile(r'^!!!\s+(\S+)(?:\s+"([^"]*)")?\s*$')


def preprocess(text: str) -> str:
    out = []
    in_adm = False
    for line in text.split('\n'):
        m = ADMONITION_RE.match(line)
        if m:
            if in_adm:
                out.append(':::')
                out.append('')
            kind = m.group(1)
            title = m.group(2)
            attrs = '.admonition .' + kind
            if title:
                escaped = title.replace('\\', '\\\\').replace('"', '\\"')
                attrs += ' title="' + escaped + '"'
            out.append('::: {' + attrs + '}')
            in_adm = True
            continue
        if in_adm:
            if line.startswith('    '):
                out.append(line[4:])
            elif line.strip() == '':
                out.append('')
            else:
                out.append(':::')
                out.append('')
                out.append(line)
                in_adm = False
        else:
            out.append(line)
    if in_adm:
        out.append(':::')
    return '\n'.join(out)


if __name__ == '__main__':
    sys.stdout.write(preprocess(sys.stdin.read()))
