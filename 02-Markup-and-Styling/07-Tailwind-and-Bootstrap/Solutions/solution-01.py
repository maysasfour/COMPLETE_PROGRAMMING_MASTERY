import re

TAILWIND_PREFIXES = ["text-", "bg-", "border-", "p-", "m-", "w-", "h-", "rounded-"]

# Matches a backtick template literal that contains a ${...} interpolation.
TEMPLATE_LITERAL_PATTERN = re.compile(r"`[^`]*\$\{[^}]*\}[^`]*`")


def find_dynamic_class_risks(js_source):
    risky = []
    for match in TEMPLATE_LITERAL_PATTERN.finditer(js_source):
        literal = match.group(0)
        if any(prefix in literal for prefix in TAILWIND_PREFIXES):
            risky.append(literal)
    return risky


if __name__ == "__main__":
    print(find_dynamic_class_risks("el.className = `text-${color}-600`;"), "(expected 1 risky snippet)")
    print(find_dynamic_class_risks('el.className = "text-red-600";'), "(expected [] -- fully static)")

    demo_snippet = '''
    const color = "purple";
    const shade = "600";
    document.getElementById("dynamic-broken").className = `text-${color}-${shade}`;
    '''
    print(find_dynamic_class_risks(demo_snippet), "(this lesson's own demo, correctly flagged)")
