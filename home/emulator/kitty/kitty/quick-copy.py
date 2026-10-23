import re

def mark(text, args, Mark, extra_cli_args, *a):
    # 按优先级收集匹配区间，避免重叠（URL/路径/hash 优先于普通单词）
    spans = []

    def add(pattern, flags=0):
        for m in re.finditer(pattern, text, flags):
            s, e = m.span()
            if any(s < pe and e > ps for ps, pe, _ in spans):
                continue
            spans.append((s, e, m.group(0)))

    add(r'https?://[^\s]+')
    add(r'(?:~|\.{1,2})?/(?:[^\s/]+/)*[^\s/]+')
    add(r'\b[0-9a-f]{7,40}\b')
    add(r'\w{2,}')

    spans.sort(key=lambda x: x[0])
    for idx, (s, e, raw) in enumerate(spans):
        mark_text = raw.replace('\n', '').replace('\0', '')
        yield Mark(idx, s, e, mark_text, {})
